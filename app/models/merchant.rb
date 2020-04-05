class Merchant < ApplicationRecord
  include Clearance::User

  has_many :queue_slots, 
    dependent: :destroy

  def admit(index=0)
    sql = admit_sql + index.to_s

    #Self.connection.exec_query(sql + index)
    #class.connection.execute(sql + index)
  end

  def boot(index=0, boot_length=10)
    
  end

  def admit_sql
'''
SELECT * FROM (
  SELECT
    ROW_NUMBER() OVER (ORDER BY key ASC) AS rownumber,
    columns
  FROM queue_slots
) AS foo
WHERE rownumber <= 
''' 
  end

end
