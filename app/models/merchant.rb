class Merchant < ApplicationRecord
  include Clearance::User

  has_many :queue_slots, dependent: :destroy
  has_many :users, through: queue_slots, order_by: queue_id, dependent: :destroy

end
