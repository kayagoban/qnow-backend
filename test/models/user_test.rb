require 'test_helper'

class UserTest < ActiveSupport::TestCase

  test "can create user" do
    user = User.create(
    )

    assert user.valid?
  end

  test "can join queue" do
    user = User.create(
    )

    merchant = User.create(
      name: Faker::Name.name, 
    )

    q = QueueSlot.create(merchant: merchant, client: user)

    assert q.valid?
  end

  test "can't have multiple queueslots per merchant" do
    user = User.create(
    )

    merchant = User.create(
      name: Faker::Name.name, 
    )

    q = QueueSlot.create(client: user, merchant: merchant)

    assert q.valid?

    r = QueueSlot.create(client: user, merchant: merchant)

    assert_not r.valid?

  end

  test "deletes queue when user is deleted" do
    user = User.create(
    )

    merchant = User.create(
      name: Faker::Name.name, 
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
    )

    (1..10).each do
      user = User.create(
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
    )

    (1..10).each do
      user = User.create(
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
    )

    (1..10).each do
      user = User.create(
      )

      q = QueueSlot.create(
        merchant: merchant, 
        client: user
      )
    end

    merchant.admit
    assert merchant.owned_queue_slots.count == 9

  end


  test 'can boot a user back through the line' do
    merchant = User.create(
      name: Faker::Name.name, 
    )

    # unrelated QueueSlots
    (1..5).each do
      QueueSlot.create(merchant: User.create, client: User.create)
    end

    (1..20).each do
      user = User.create(
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
    rows = merchant.get_rows(3, 8)
    booted_client_id = rows.first['client_id']
    last_client_id = rows.last['client_id']
    merchant.boot(3, 8)
    rows = merchant.get_rows(3, 8)
    assert rows.first['client_id'] == booted_client_id + 1
    assert rows.last['client_id'] == booted_client_id
    rows.delete(rows.last)
    assert rows.last['client_id'] == last_client_id
  end

  test 'overbooting places a user in the last row' do
    merchant = User.create(
      name: Faker::Name.name, 
    )

    # unrelated QueueSlots
    (1..5).each do
      QueueSlot.create(merchant: User.create, client: User.create)
    end



    (1..5).each do
      user = User.create(
      )

      q = QueueSlot.create(
        merchant: merchant, client: user
      )
    end

    # unrelated QueueSlots
    (1..5).each do
      QueueSlot.create(merchant: User.create, client: User.create)
    end


    # boot 3 to 8 and move everyone else up one.
    rows = merchant.get_rows(3, 8)
    booted_client_id = rows.first['client_id']
    last_client_id = rows.last['client_id']
    merchant.boot(3, 8)
    rows = merchant.get_rows(3, 8)
    assert rows.first['client_id'] == booted_client_id + 1 
    assert rows.last['client_id'] == booted_client_id
    assert QueueSlot.find(rows.last['id']).booted == true
    rows.delete(rows.last)
    assert rows.last['client_id'] == last_client_id 
  end

  test 'when user is destroyed, all known_merchants should be destroyed' do
    merchant = User.create(
      name: Faker::Name.name, 
    )
    merchant2 = User.create(
      name: Faker::Name.name, 
    )
    client = User.create

    client.known_merchants << [merchant, merchant2]
    km = KnownMerchantUser.where(merchant: [merchant, merchant2])
    assert km.length == 2
    client.destroy
    km = KnownMerchantUser.where(merchant: [merchant, merchant2])
    assert km.length == 0

  end

  test 'when merchant is destroyed, all known_merchants should be destroyed' do
    merchant = User.create(
      name: Faker::Name.name, 
    )
    merchant2 = User.create(
      name: Faker::Name.name, 
    )
    client = User.create

    client.known_merchants << [merchant, merchant2]
    km = KnownMerchantUser.where(merchant: [merchant, merchant2])
    assert km.length == 2
    merchant.destroy
    assert client.known_merchants.reload == [merchant2]

  end



end
