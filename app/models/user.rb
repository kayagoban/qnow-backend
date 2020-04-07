class User < ApplicationRecord
  #include Clearance::User

  class BootException < Exception; end

  has_many :joined_queue_slots, class_name:  'QueueSlot', foreign_key: :client_id, dependent: :destroy, inverse_of: :client
  has_many :owned_queue_slots, class_name:  'QueueSlot', foreign_key: :merchant_id, dependent: :destroy, inverse_of: :merchant

  #client-role relationships

  def merchants
    User.joins('INNER JOIN "queue_slots" ON "queue_slots"."merchant_id" = "users"."id" where "queue_slots"."client_id" = ' + id.to_s)
  end

  # merchant-role relationships
  
  def clients
    User.joins('INNER JOIN "queue_slots" ON "queue_slots"."client_id" = "users"."id" where "queue_slots"."merchant_id" = ' + id.to_s)
  end

  def admit
    owned_queue_slots.first.destroy
  end

  def boot(position, destination)
    if destination.nil? or destination <= position
      raise BootException.new('destination must be greater than current position')
    end

    rows = get_rows(position, destination)

    row_ids = rows.map do |row|
      row['client_id']
    end

    shifted = row_ids.shift
    row_ids.push(shifted)

    # in a transaction because we may temporarily be in
    # a state where users have more than one slot per merchant
    #
    ActiveRecord::Base.transaction do
      rows.each_with_index do |row, index|
        # update_attribute skips the uniqueness validation
        QueueSlot.find(row['id']).update_attribute('client_id', row_ids[index])
      end
    end

  end

  def get_row(position)
    sql = find_row_sql + position.to_s
    ActiveRecord::Base.connection.execute(sql)
  end

  def get_rows(position, destination)
    ActiveRecord::Base.connection.execute(
      find_rows_sql(
        position, destination
      )
    )
  end

  def find_rows_sql(from, to)
'
SELECT * FROM (
  SELECT
    id,
    merchant_id,
    client_id,
    ROW_NUMBER() OVER (ORDER BY id ASC) AS rownumber
  FROM queue_slots
) AS foo
WHERE rownumber >= ' + from.to_s + ' AND rownumber <= ' + to.to_s
 
  end

  def find_row_sql
'''
SELECT * FROM (
  SELECT
    *,
    ROW_NUMBER() OVER (ORDER BY id ASC) AS rownumber
  FROM queue_slots
) AS foo
WHERE rownumber = 
''' 
  end

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
