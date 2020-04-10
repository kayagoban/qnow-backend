require 'test_helper'


class UsersControllerTest < ActionController::TestCase


  test 'get /known_merchants' do # test_get_merchants
    merchant = User.create(
      name: 'Konzum super', 
      #session_id: SecureRandom.alphanumeric
    )
    merchant2 = User.create(
      name: 'Ljekarna', 
      #session_id: SecureRandom.alphanumeric
    )
    merchant3 = User.create(
      name: 'Lidl u centru grada', 
      #session_id: SecureRandom.alphanumeric
    )
    client = User.create

    client.known_merchants << [merchant, merchant2, merchant3]

    @request.session[:user_id] = client.id

    get 'known_merchants'

    r = JSON.parse @response.body

    assert r.count == 3
    assert r.last['name'] == 'Lidl u centru grada'

  end

  test 'post /merchants/:id/enqueue' do
  end

  test 'post /merchants/:id/dequeue' do
  end

  test 'get /status' do
  end


  #  test 'create merchant' do
  #    post '/users'
  #    assert_response :success
  #  end

  #test 'get merchant slots' do
  #  get '/merchants/1/slots'#, params: { id: 1 }
  #, action: 'slots'
  #  assert_response :success
  #assert_template :index
  #assert_not_nil assigns(:news)
  #end

  #test 'enqueue to merchant' do
  #  post '/merchants/1/enqueue'
  #  #, params: { id: 1 }
  #  #, action: 'slots'
  #  assert_response :success
  ##  #assert_template :index
  #  #assert_not_nil assigns(:news)
  #  end
  # 

  # test "the truth" do
  #   assert true
  # end
  #
  # test "can create an article" do
  #   get "/articles/new"
  #   assert_response :success

  #   post "/articles",
  #   params: { article: { title: "can create", body: "article successfully." } }
  #  assert_response :redirect
  #  follow_redirect!
  #  assert_response :success
  #  assert_select "p", "Title:\n  can create"
  #end
  #

end
