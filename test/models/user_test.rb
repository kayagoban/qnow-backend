require 'test_helper'
require 'pry'

class UserTest < ActiveSupport::TestCase

  test "user validates inputs" do
    user = User.create(email: "cthomas@railjumper.com", password: "asdf")
    assert user.valid?
  end

  test "can create user" do
    #binding.pry
    user = User.create(email: "zzzzz", password: "asdf")
    assert !user.valid?
  end

  test "can join queue" do
    user = User.create(email: "cthomas@railjumper.com", password: "asdf")
    merchant = Merchant.create(email: "k@konzum.hr", password: "asdf")

    q = user.join(merchant.id)

    assert q.valid?
  end

  test "can't have multiple queueslots per merchant" do
    user = User.create(email: "cthomas@railjumper.com", password: "asdf")
    merchant = Merchant.create(email: "k@konzum.hr", password: "asdf")

    q = QueueSlot.create(user: user, merchant: merchant)

    assert q.valid?

    r = QueueSlot.create(user: user, merchant: merchant)

    assert_not r.valid?

  end

  test "deletes queue when user is deleted" do
    user = User.create(email: "cthomas@railjumper.com", password: "asdf")
    merchant = Merchant.create(email: "k@konzum.hr", password: "asdf")

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
