require 'test_helper'


class UsersControllerTest < ActionController::TestCase


  test 'get /known_merchants' do # test_get_merchants
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
    get :known_merchants
    assert @response.status == 401

    @request.session[:user_id] = 414141 
    # still unauthorized
    get :known_merchants
    assert @response.status == 401

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

    assert @response.status == 404

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

    delete :dequeue, params: { id: merchant3.id }
    r = JSON.parse @response.body
    assert @response.status == 404

    client.joined_queue_slots.create(merchant: merchant3)

    delete :dequeue, params: { id: merchant3.id }
    r = JSON.parse @response.body
    assert @response.status == 200
    assert client.joined_queue_slots.count == 0
    assert merchant3.owned_queue_slots.count == 1

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

  test 'get merchant' do

    merchant = User.create(
      name: 'Konzum super', 
    )

    get 'merchant', params: { join_code: merchant.join_code }

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
