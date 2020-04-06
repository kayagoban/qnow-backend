require 'test_helper'
require 'pry'

class UserTest < ActiveSupport::TestCase

  test "can create user" do
    user = User.create(
      session_id: SecureRandom.alphanumeric
    )

    assert user.valid?
  end

  test "can join queue" do
    user = User.create(
      session_id: SecureRandom.alphanumeric
    )

    merchant = Merchant.create(
      name: Faker::Name.name, 
      session_id: SecureRandom.alphanumeric
    )



    q = user.join(merchant.id)

    assert q.valid?
  end

  test "can't have multiple queueslots per merchant" do
    user = User.create(
      session_id: SecureRandom.alphanumeric
    )

    merchant = Merchant.create(
      name: Faker::Name.name, 
      session_id: SecureRandom.alphanumeric
    )



    q = QueueSlot.create(user: user, merchant: merchant)

    assert q.valid?

    r = QueueSlot.create(user: user, merchant: merchant)

    assert_not r.valid?

  end

  test "deletes queue when user is deleted" do
    user = User.create(
      session_id: SecureRandom.alphanumeric
    )

    merchant = Merchant.create(
      name: Faker::Name.name, 
      session_id: SecureRandom.alphanumeric
    )



    q = QueueSlot.create(user: user, merchant: merchant)

    user.destroy

    begin
      q = q.reload
    rescue ActiveRecord::RecordNotFound
      assert true
      return 
    rescue 
      assert false
    end

    assert false
  end


end
