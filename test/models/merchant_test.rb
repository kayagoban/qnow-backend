require 'test_helper'

class MerchantTest < ActiveSupport::TestCase

  test "can get a row" do
    merchant = Merchant.create(
      name: Faker::Name.name, 
      session_id: SecureRandom.alphanumeric
    )

    (1..10).each do
      user = User.create(
        session_id: SecureRandom.alphanumeric
      )

      q = QueueSlot.create(
        merchant: merchant, 
        user: user
      )
    end

    assert merchant.queue_slots.last.id == merchant.get_row(10).first['id'] 
  end

  test "can get rows" do
    merchant = Merchant.create(
      name: Faker::Name.name, 
      session_id: SecureRandom.alphanumeric
    )

    (1..10).each do
      user = User.create(
        session_id: SecureRandom.alphanumeric
      )

      q = QueueSlot.create(
        merchant: merchant, 
        user: user
      )
    end

    rows = merchant.get_rows(3,8)

    assert rows.count == 6  #inclusive for 3 to 8
    assert rows.first['id'] == 3
    assert rows.last['id'] == 8
  end


  test "can admit a user" do
    merchant = Merchant.create(
      name: Faker::Name.name, 
      session_id: SecureRandom.alphanumeric
    )

    (1..20).each do
      user = User.create(
        session_id: SecureRandom.alphanumeric
      )

      q = QueueSlot.create(
        merchant: merchant, 
        user: user
      )
    end

    merchant.admit
    assert merchant.queue_slots.first.user_id == 2

  end


  test 'can boot a user back through the line' do
    merchant = Merchant.create(
      name: Faker::Name.name, 
      session_id: SecureRandom.alphanumeric
    )

    (1..20).each do
      user = User.create(
        session_id: SecureRandom.alphanumeric
      )

      q = QueueSlot.create(
        merchant: merchant, 
        user: user
      )
    end

    assert_raises Merchant::BootException do
      merchant.boot(0, 0) # fails because same position as before
    end

    assert_raises Merchant::BootException do
      merchant.boot(3, 1)  # cannot boot to higher in line
    end

    # boot 3 to 8 and move everyone else up one.
    merchant.boot(3, 8)
    rows = merchant.get_rows(3, 8)
    assert rows.first['user_id'] == 4
    assert rows.last['user_id'] == 3
    rows.delete(rows.last)
    assert rows.last['user_id'] == 8
  end


end
