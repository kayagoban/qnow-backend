require 'test_helper'


class UsersControllerTest < ActionController::TestCase

  test 'get known_merchants' do # test_get_merchants
    merchant = User.create(
      name: 'Konzum super', 
    )
    merchant2 = User.create(
      name: 'Ljekarna', 
    )
    merchant3 = User.create(
      name: 'Lidl u centru grada', 
    )
    client = User.create

    client.known_merchants << [merchant, merchant2, merchant3]

    # unauthorized
    #get :known_merchants
    #assert @response.status == 401

    @request.session[:user_id] = 414141 
    # still unauthorized
    #get :known_merchants
    #assert @response.status == 401

    @request.session[:user_id] = client.id

    get :known_merchants

    r = JSON.parse @response.body

    assert r.count == 3
    assert r.last['name'] == 'Lidl u centru grada'

  end


  test 'post enqueue' do
    merchant = User.create(
      name: 'Konzum super', 
    )
    merchant2 = User.create(
      name: 'Ljekarna', 
    )
    merchant3 = User.create(
      name: 'Lidl u centru grada', 
    )
    prev_user = User.create
    prev_user.joined_queue_slots.create(merchant: merchant3)

    client = User.create
    client.known_merchants << [merchant, merchant2]
    @request.session[:user_id] = client.id


    post :enqueue, params: {  }
    assert @response.status == 404

    post :enqueue, params: { join_code: '34jl3kow' }
    r = JSON.parse @response.body
    # incorrect join code
    assert @response.status == 404

    post :enqueue, params: { join_code: merchant3.join_code }
    r = JSON.parse @response.body
    # queue not enabled
    assert @response.status == 404

    merchant3.queue_enabled = true
    merchant3.save

    post :enqueue, params: { join_code: merchant3.join_code }
    r = JSON.parse @response.body

    assert r['position'] == 2
    assert r['id'] == merchant3.id 


  end

  test 'post dequeue' do
    merchant = User.create(
      name: 'Konzum super', 
    )
    merchant2 = User.create(
      name: 'Ljekarna', 
    )
    merchant3 = User.create(
      name: 'Lidl u centru grada', 
    )
    prev_user = User.create
    prev_user.joined_queue_slots.create(merchant: merchant3)

    client = User.create

    @request.session[:user_id] = client.id

    client.known_merchants << [merchant, merchant2]

    client.joined_queue_slots.create(merchant: merchant3)

    delete :dequeue, params: { id: merchant3.id }
    r = JSON.parse @response.body
    # queue not enabled
    assert @response.status == 404

    merchant3.queue_enabled = true
    merchant3.save

    delete :dequeue, params: { id: merchant3.id }
    r = JSON.parse @response.body

    assert @response.status == 200
    assert client.joined_queue_slots.count == 0
    assert merchant3.owned_queue_slots.count == 1

  end

  test 'post enable_queue' do
    client = User.create
    @request.session[:user_id] = client.id
    post 'enable_queue'
    assert client.reload.queue_enabled?
  end

  test 'post disable_queue' do
    merchant = User.create
    User.create.merchants << merchant
    User.create.merchants << merchant
    User.create.merchants << merchant
    @request.session[:user_id] = merchant.id

    post 'disable_queue'
    assert_not merchant.reload.queue_enabled?
    assert merchant.owned_queue_slots.count == 0
  end

  test 'post transfer' do
    original_client = User.create
    merchant = User.create
    original_client.merchants << merchant

    new_client = User.create
    @request.session[:user_id] = new_client.id
 
    post 'transfer', params: { transfer_code: original_client.transfer_code }
    assert @request.session[:user_id] == original_client.id
    assert_raises(ActiveRecord::RecordNotFound) do
      new_client.reload
    end
    
  end

  test 'get status' do

    merchant = User.create(
      name: 'Konzum super', 
    )
    merchant2 = User.create(
      name: 'Ljekarna', 
    )
    merchant3 = User.create(
      name: 'Lidl u centru grada', 
    )
    prev_user = User.create
    prev_user.joined_queue_slots.create(merchant: merchant3)
    client = User.create

    @request.session[:user_id] = client.id

    client.known_merchants << [merchant, merchant2]

    client.joined_queue_slots.create(merchant: merchant3)

    get 'status'

    r = JSON.parse @response.body

    assert @response.status == 200
    assert r.count == 3
    assert r.last['pos'] == 2

  end

  test 'post add_merchant' do

    merchant = User.create(
      name: 'Konzum super', 
    )

    post 'add_merchant', params: { join_code: merchant.join_code }

    r = JSON.parse @response.body

    assert @response.status == 200
    assert r['name'] == merchant.name

  end

  test 'get transfer_code' do
    client = User.create
    @request.session[:user_id] = client.id

    get 'transfer_code'

    r = JSON.parse @response.body

    assert client.transfer_code == r['transfer_code']



  end

end
