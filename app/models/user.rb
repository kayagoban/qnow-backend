class User < ApplicationRecord

  class BootException < Exception; end


  before_create :set_codes

  # merchant role associations
  has_many :known_client_joins, class_name: 'KnownMerchantUser', foreign_key: :merchant_id, dependent: :destroy, inverse_of: :merchant

  has_many :known_clients, through: :known_client_joins, source: :client

  has_many :owned_queue_slots, class_name:  'QueueSlot', foreign_key: :merchant_id, dependent: :destroy, inverse_of: :merchant

  # current clients who have a queueslot
  has_many :clients, through: :owned_queue_slots, source: :client


  # client role associations
  has_many :known_merchant_joins, class_name: 'KnownMerchantUser', foreign_key: :client_id, dependent: :destroy, inverse_of: :client

  has_many :known_merchants, through: :known_merchant_joins, source: :merchant

  has_many :joined_queue_slots, class_name:  'QueueSlot', foreign_key: :client_id, dependent: :destroy, inverse_of: :client

  # current merchants who we have a queueslot for
  has_many :merchants, through: :joined_queue_slots, source: :merchant


  def set_codes
    self.transfer_code = SecureRandom.alphanumeric
    self.join_code = SecureRandom.alphanumeric
  end

 
  #################################################
  # Client role methods

  def enqueue_for_merchant(merchant_id)
    QueueSlot.create(user: self, merchant_id: merchant_id)
  end




  #################################################
  # Merchant role methods

  def admit
    return if owned_queue_slots.empty?
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

      q = QueueSlot.find(rows.last['id'])
      q.booted = true
      q.save
    end

  end


  # methods to get numbered rows for merchant
  def get_row(position)
    sql = find_row_sql(self.id, position)
    ActiveRecord::Base.connection.execute(sql)
  end

  def get_rows(start_position, end_position)
    ActiveRecord::Base.connection.execute(
      find_rows_sql(
        self.id, start_position, end_position 
      )
    )
  end

  def find_rows_sql(merchant_id, from, to)
'
SELECT * FROM (
  SELECT
    id,
    merchant_id,
    client_id,
    ROW_NUMBER() OVER (ORDER BY id ASC) AS rownumber
  FROM queue_slots WHERE merchant_id = ' + merchant_id.to_s + '
) AS foo
WHERE rownumber >= ' + from.to_s + ' AND rownumber <= ' + to.to_s
 
  end

  def find_row_sql(merchant_id, position)
'
SELECT * FROM (
  SELECT
    *,
    ROW_NUMBER() OVER (ORDER BY id ASC) AS rownumber
  FROM queue_slots WHERE merchant_id = ' + merchant_id.to_s + '
) AS foo
WHERE rownumber = 
    ' + position.to_s
  end


end
