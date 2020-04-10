require 'test_helper'


#class UsersControllerTest < ActionDispatch::IntegrationTest

class UsersControllerTest < ActionController::TestCase

  persisted_session = ActionController::TestSession.new
  #stub :session => persisted_session

  test 'blah' do # test_get_merchants
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

    sess = ActionController::TestSession.new
    binding.pry

    get 'known_merchants'
    get 'known_merchants'

    binding.pry

 end
=begin
  test 'post /merchants/:id/enqueue' do
  end

  test 'post /merchants/:id/dequeue' do
  end

  test 'get /known_merchants' do
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

    get 'known_merchants', session: { user_id: 1 }

  end

  test 'get /queues' do
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
=end

end
