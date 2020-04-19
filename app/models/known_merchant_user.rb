class KnownMerchantUser < ApplicationRecord
  belongs_to :client, foreign_key: 'client_id', class_name: 'User', inverse_of: :known_client_joins

  belongs_to :merchant, foreign_key: 'merchant_id', class_name: 'User', inverse_of: :known_merchant_joins

  validates :client, uniqueness: { scope: :merchant }

end
