class QueueSlot < ApplicationRecord

  belongs_to :user
  belongs_to :merchant

  validates :user, uniqueness: { scope: :merchant }


end

