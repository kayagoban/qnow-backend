class KnownMerchantUser < ApplicationRecord
  belongs_to :client, foreign_key: 'client_id', class_name: 'User', inverse_of: :known_client_joins

  belongs_to :merchant, foreign_key: 'merchant_id', class_name: 'User', inverse_of: :known_merchant_joins

  validates :client, uniqueness: { scope: :merchant }

  after_create :touch_client
  before_destroy :touch_client

  def touch_client
    client.touch
    client.save
  end

end
