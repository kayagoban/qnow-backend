class QueueSlot < ApplicationRecord

  belongs_to :merchant, foreign_key: 'merchant_id', class_name: 'User'
  belongs_to :client, foreign_key: 'client_id', class_name: 'User'

  validates :client, uniqueness: { scope: :merchant }


end

