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

    merchant = User.create(
      name: Faker::Name.name, 
      session_id: SecureRandom.alphanumeric
    )


    q = QueueSlot.create(merchant: merchant, client: user)

    assert q.valid?
  end

  test "can't have multiple queueslots per merchant" do
    user = User.create(
      session_id: SecureRandom.alphanumeric
    )

    merchant = User.create(
      name: Faker::Name.name, 
      session_id: SecureRandom.alphanumeric
    )

    q = QueueSlot.create(client: user, merchant: merchant)

    assert q.valid?

    r = QueueSlot.create(client: user, merchant: merchant)

    assert_not r.valid?

  end

  test "deletes queue when user is deleted" do
    user = User.create(
      session_id: SecureRandom.alphanumeric
    )

    merchant = User.create(
      name: Faker::Name.name, 
      session_id: SecureRandom.alphanumeric
    )

    q = QueueSlot.create(client: user, merchant: merchant)

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

  test "can get a queueslot" do
    merchant = User.create(
      name: Faker::Name.name, 
      session_id: SecureRandom.alphanumeric
    )

    (1..10).each do
      user = User.create(
        session_id: SecureRandom.alphanumeric
      )

      q = QueueSlot.create(
        merchant: merchant, 
        client: user
      )
    end

    assert merchant.owned_queue_slots.last.id == merchant.get_row(10).first['id'] 
  end

  test "can get queueslots" do
    merchant = User.create(
      name: Faker::Name.name, 
      session_id: SecureRandom.alphanumeric
    )

    (1..10).each do
      user = User.create(
        session_id: SecureRandom.alphanumeric
      )

      q = QueueSlot.create(
        merchant: merchant, 
        client: user
      )
    end

    rows = merchant.get_rows(3,8)

    assert rows.count == 6  #inclusive for 3 to 8
    assert rows.first['id'] == 3
    assert rows.last['id'] == 8
  end


  test "can admit a user" do
    merchant = User.create(
      name: Faker::Name.name, 
      session_id: SecureRandom.alphanumeric
    )

    (1..10).each do
      user = User.create(
        session_id: SecureRandom.alphanumeric
      )

      q = QueueSlot.create(
        merchant: merchant, 
        client: user
      )
    end

    merchant.admit
    assert merchant.owned_queue_slots.reload.first.client_id == 3

  end


  test 'can boot a user back through the line' do
    merchant = User.create(
      name: Faker::Name.name, 
      session_id: SecureRandom.alphanumeric
    )

    (1..20).each do
      user = User.create(
        session_id: SecureRandom.alphanumeric
      )

      q = QueueSlot.create(
        merchant: merchant, 
        client: user
      )
    end

    assert_raises User::BootException do
      merchant.boot(0, 0) # fails because same position as before
    end

    assert_raises User::BootException do
      merchant.boot(3, 1)  # cannot boot to higher in line
    end

    # boot 3 to 8 and move everyone else up one.
    merchant.boot(3, 8)
    rows = merchant.get_rows(3, 8)
    assert rows.first['client_id'] == 5
    assert rows.last['client_id'] == 4
    rows.delete(rows.last)
    assert rows.last['client_id'] == 9 
  end

  test 'overbooting places a user in the last row' do
    merchant = User.create(
      name: Faker::Name.name, 
      session_id: SecureRandom.alphanumeric
    )

    (1..5).each do
      user = User.create(
        session_id: SecureRandom.alphanumeric
      )

      q = QueueSlot.create(
        merchant: merchant, 
        client: user
      )
    end

    # boot 3 to 8 and move everyone else up one.
    merchant.boot(3, 8)
    rows = merchant.get_rows(3, 8)
    assert rows.first['client_id'] == 5
    assert rows.last['client_id'] == 4
    rows.delete(rows.last)
    assert rows.last['client_id'] == 6 
  end

  test 'when user is destroyed, all known_merchants should be destroyed' do
    merchant = User.create(
      name: Faker::Name.name, 
      session_id: SecureRandom.alphanumeric
    )
    merchant2 = User.create(
      name: Faker::Name.name, 
      session_id: SecureRandom.alphanumeric
    )
    client = User.create

    client.known_merchants << [merchant, merchant2]
    km = KnownMerchantUser.where(merchant: [merchant, merchant2])
    assert km.length == 2
    client.destroy
    km = KnownMerchantUser.where(merchant: [merchant, merchant2])
    assert km.length == 0

  end



end
