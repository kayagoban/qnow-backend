class KnownMerchantUser < ApplicationRecord
  belongs_to :client, foreign_key: 'client_id', class_name: 'User', inverse_of: :known_merchant_users
  belongs_to :merchant, foreign_key: 'merchant_id', class_name: 'User', inverse_of: :known_merchants
end
