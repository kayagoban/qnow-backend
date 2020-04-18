require 'test_helper'
require 'faker'

class QueueSlotTest < ActiveSupport::TestCase
  test 'when queue_slot is created, a known_merchant_user is created' do
    assert KnownMerchantUser.all.count == 0
    merchant = User.create
    client = User.create
    q = QueueSlot.create(merchant: merchant, client: client)
    kmus = KnownMerchantUser.all
    assert kmus.count == 1
    assert kmus.first.merchant == merchant
    assert kmus.first.client = client
  end

  test 'when queue_slot is recreated, no additional known_merchant_user is created' do
    assert KnownMerchantUser.all.count == 0
    merchant = User.create
    client = User.create
    q = QueueSlot.create(merchant: merchant, client: client)
    kmus = KnownMerchantUser.all
    assert kmus.count == 1
    assert kmus.first.merchant == merchant
    assert kmus.first.client = client
 
    q.destroy

    q = QueueSlot.create(merchant: merchant, client: client)

    kmus = KnownMerchantUser.all
    assert kmus.count == 1
    assert kmus.first.merchant == merchant
    assert kmus.first.client = client
  end

  test 'reload positions' do
    assert KnownMerchantUser.all.count == 0
    merchant = User.create
    client = User.create
    client.merchants << merchant
    client2 = User.create
    client2.merchants << merchant
    mjs = KnownMerchantUser.where(merchant: merchant)
    assert mjs.first.position == 1
    assert mjs.last.position == 2
  end



end
