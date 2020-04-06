class User < ApplicationRecord
  #include Clearance::User

  has_many :queue_slots, 
    dependent: :destroy


  def queues
    return queue_slots

    # for each queue slot for the user,
    # check the merchant.
    # get merchant name, total queued 
    # slots for merchant, and 
    # current slot number of the user.

    #queue_slots.map do |slot|
    #  slot.merchant.queue_slots 
    
    #User.connection.execute('SELECT *, ROW_NUMBER() over (order by id) as rownum from queue_slots where merchant_id = 1')

  end

  def join(merchant_id)
    QueueSlot.create(user: self, merchant_id: merchant_id)
  end

end
