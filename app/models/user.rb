class User < ApplicationRecord
  include Clearance::User

  has_many :queue_slots, dependent: :destroy
end
