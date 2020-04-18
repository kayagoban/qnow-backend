class QueueSlot < ApplicationRecord

  belongs_to :merchant, foreign_key: 'merchant_id', class_name: 'User', inverse_of: :owned_queue_slots, counter_cache: true, touch: true
  belongs_to :client, foreign_key: 'client_id', class_name: 'User', inverse_of: :joined_queue_slots

  validates :client, uniqueness: { scope: :merchant }
  validates :merchant, null: false

  # create kmu
  before_create :create_known_association

  after_create :update_queue_positions

  # null out the position on the kmu
  before_destroy :remove_queue_position

  after_destroy :update_queue_positions

  def remove_queue_position
    kmu = KnownMerchantUser.where(merchant: merchant, client: client).first
    if not kmu.nil?
      kmu.position = nil
      kmu.save
    end
  end

  def update_queue_positions
    ActiveRecord::Base.connection.execute(update_positions_sql)
  end

  def create_known_association
    KnownMerchantUser.create(merchant: merchant, client: client)
  end

  def position
    get_position.first['rownumber']
  end

  def get_position
    ActiveRecord::Base.connection.execute(find_position_sql)
  end

  def find_position_sql
'
SELECT * FROM (
  SELECT
    *,
    ROW_NUMBER() OVER (ORDER BY id ASC) AS rownumber
  FROM queue_slots WHERE merchant_id = ' + self.merchant_id.to_s + '
) AS foo
WHERE client_id = 
    ' + self.client_id.to_s
  end

  def update_positions_sql
    "
UPDATE known_merchant_users
SET position = ordered_queue.rownumber
FROM
     ( SELECT
      merchant_id,
      client_id,
      ROW_NUMBER() OVER (
        ORDER BY
          id ASC
      ) AS rownumber
    FROM
      queue_slots
    WHERE
      merchant_id = #{merchant_id} ) as ordered_queue
WHERE known_merchant_users.client_id = ordered_queue.client_id
 AND
 known_merchant_users.merchant_id = ordered_queue.merchant_id
"
  end

end

