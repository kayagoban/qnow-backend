class QueueSlot < ApplicationRecord

  belongs_to :merchant, foreign_key: 'merchant_id', class_name: 'User', inverse_of: :owned_queue_slots
  belongs_to :client, foreign_key: 'client_id', class_name: 'User', inverse_of: :joined_queue_slots

  validates :client, uniqueness: { scope: :merchant }


end

