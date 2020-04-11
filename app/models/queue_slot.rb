class QueueSlot < ApplicationRecord

  belongs_to :merchant, foreign_key: 'merchant_id', class_name: 'User', inverse_of: :owned_queue_slots, counter_cache: true
  belongs_to :client, foreign_key: 'client_id', class_name: 'User', inverse_of: :joined_queue_slots

  validates :client, uniqueness: { scope: :merchant }
  validates :merchant, null: false

  before_create :create_known_association

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



end

