class Merchant < ApplicationRecord
  include Clearance::User

  has_many :queue_slots, 
    dependent: :destroy

  has_many :users, 
    through: queue_slots, 
    order_by: queue_id, 
    dependent: :destroy

  def admit(index=0)
    sql = '''
SELECT * FROM (
  SELECT
    ROW_NUMBER() OVER (ORDER BY key ASC) AS rownumber,
    columns
  FROM queue_slots
) AS foo
WHERE rownumber <= 
    '''

    #Self.connection.exec_query(sql + index)
    Self.connection.execute(sql + index)
  end

  def boot(index=0, boot_length=10)
    
  end

end
