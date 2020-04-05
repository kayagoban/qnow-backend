require 'test_helper'

class MerchantTest < ActiveSupport::TestCase

  test "can admit a user" do
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

    r = merchant.admit(0)
    binding.pry


  end


end
