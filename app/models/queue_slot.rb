class QueueSlot < ApplicationRecord

  belongs_to :merchant, foreign_key: 'merchant_id', class_name: 'User', inverse_of: :owned_queue_slots, counter_cache: true
  belongs_to :client, foreign_key: 'client_id', class_name: 'User', inverse_of: :joined_queue_slots

  validates :client, uniqueness: { scope: :merchant }

  after_create do
    KnownMerchantUser.create(merchant: merchant, client: client)
  end




end

