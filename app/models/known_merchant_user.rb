class KnownMerchantUser < ApplicationRecord
  belongs_to :client, foreign_key: 'client_id', class_name: 'User', inverse_of: :known_client_joins

  belongs_to :merchant, foreign_key: 'merchant_id', class_name: 'User', inverse_of: :known_merchant_joins

  validates :client, uniqueness: { scope: :merchant }

  attr_accessor :position


  def position
    if merchant.queue_slots_count == 0
      return 0 
    end

    begin
      QueueSlot.find_by(client_id: client_id, merchant_id: merchant_id).position
    rescue
      return 0 
    end
  end

end
