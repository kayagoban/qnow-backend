require 'test_helper'
require 'faker'
require 'pry'

class QueueSlotTest < ActiveSupport::TestCase
  begin
    Merchant.connection  
  rescue 
    nil
  end


  test "can add a bunch of users" do
    merchant = Merchant.create(
      email: Faker::Internet.email, 
      name: Faker::Name.name, 
      password: SecureRandom.alphanumeric
    )


    (1..20).each do
      user = User.create(
        email: Faker::Internet.email, 
        name: Faker::Name.name, 
        password: SecureRandom.alphanumeric
      )
      q = QueueSlot.create(
        merchant: merchant, 
        user: user
      )
 
    end

    assert merchant.queue_slots.count == 20
  end




end
