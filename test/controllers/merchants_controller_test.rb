require 'test_helper'

class MerchantsControllerTest < ActionDispatch::IntegrationTest
  test 'create merchant' do
    post '/merchants'
    assert_response :success
  end
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
end
