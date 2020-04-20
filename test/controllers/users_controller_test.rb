require 'test_helper'


class UsersControllerTest < ActionController::TestCase

   # outrageously verbose DB messages
   #ActiveRecord::Base.logger = Logger.new(STDOUT) if defined?(ActiveRecord::Base)

  test 'post join_queue' do
 
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
    prev_user_updated_at = prev_user.reload.updated_at

    client = User.create
    client_updated_at = client.updated_at
    client.known_merchants << [merchant, merchant2]
    @request.session[:user_id] = client.id

    post :join_queue, params: { join_code: '34jl3kow' }
    # incorrect join code
    assert @response.status == 404

    post :join_queue, params: { join_code: merchant3.join_code }
    # queue not enabled
    assert @response.status == 404

    merchant3.queue_enabled = true
    merchant3.save

    post :join_queue, params: { join_code: merchant3.join_code }

    client.reload
    merchant3.reload
    prev_user.reload

    assert @response.status == 302 
    assert client.merchants.include?(merchant3)
    assert client.known_merchant_joins.find_by_merchant_id(merchant3.id).position == 2
    assert client_updated_at < client.updated_at
    assert prev_user_updated_at < prev_user.updated_at

  end

  test 'post exit_queue' do
    merchant = User.create(
      name: 'Konzum super', 
    )
    merchant2 = User.create(
      name: 'Ljekarna', 
    )
    merchant3 = User.create(
      name: 'Lidl u centru grada', 
      queue_enabled: true
    )
    prev_user = User.create
    prev_user.merchants << merchant3

    client = User.create

    @request.session[:user_id] = client.id

    client.known_merchants << [merchant, merchant2]

    client.merchants << merchant3

    assert merchant3.reload.clients.count == 2 

    post :exit_queue, params: { join_code: merchant3.join_code }
    assert @response.status == 302
    assert client.merchants.count == 0
    assert merchant3.reload.clients.count == 1

    get 'status'
    assert @response.status == 200

    @request.headers['If-Modified-Since'] = @response.headers['Last-Modified']
    get 'status'
    assert @response.status == 304


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

    assert @response.status == 200

    @request.headers['If-Modified-Since'] = @response.headers['Last-Modified']

    get 'status'

    assert @response.status == 304

  end

  test 'get add_queue' do

    merchant = User.create(
      name: 'Konzum super', 
    )

    client = User.create
    updated_time = client.updated_at

    @request.session[:user_id] = client.id

    get 'add_queue', params: { id: merchant.join_code }

    client.reload

    assert client.known_merchants.include?(merchant)
    assert client.updated_at != updated_time
    assert @response.status == 302

    get 'status'

    assert @response.status == 200

    @request.headers['If-Modified-Since'] = @response.headers['Last-Modified']

    get 'status'

    assert @response.status == 304

  end

  test 'get remove_queue' do

    merchant = User.create(
      name: 'Konzum super', 
    )
    client = User.create
    client.known_merchants << merchant
    updated_time = client.updated_at

    @request.session[:user_id] = client.id

    get 'remove_queue', params: { join_code: merchant.join_code }

    client.reload

    assert @response.status == 302
    assert_not client.known_merchants.include?(merchant)
    assert client.updated_at > updated_time
  end

  test 'get transfer_code' do
    client = User.create
    @request.session[:user_id] = client.id

    get 'transfer_code'


  end

end
