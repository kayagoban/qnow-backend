require 'test_helper'
require 'faker'
require 'pry'

class QueueSlotTest < ActiveSupport::TestCase

#  begin
#    ActiveRecord::Base.connection  
#  rescue 
#    nil
#  end

  test "can add a bunch of users" do
    merchant = Merchant.create(
      name: Faker::Name.name, 
      session_id: SecureRandom.alphanumeric
    )

    (1..20).each do
      user = User.create(
        session_id: SecureRandom.alphanumeric
      )
      q = QueueSlot.create(
        merchant: merchant, 
        user: user
      )
 
    end

    assert merchant.queue_slots.count == 20
  end


end
