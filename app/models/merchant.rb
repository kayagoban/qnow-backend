class Merchant < ApplicationRecord
  require 'pry'

  class BootException < Exception; end

  #include Clearance::User

  has_many :queue_slots, 
    dependent: :destroy

  def admit
    queue_slots.first.destroy
  end

  def boot(position, destination)
    if destination.nil? or destination <= position
      raise BootException.new('destination must be greater than current position')
    end

    rows = get_rows(position, destination)

    row_ids = rows.map do |row|
      row['id']
    end

    shifted = row_ids.shift
    row_ids.push(shifted)

    # in a transaction because we may temporarily be in
    # a state where users have more than one slot per merchant
    #
    ActiveRecord::Base.transaction do
      rows.each_with_index do |row, index|
        # update_attribute skips the uniqueness validation
        QueueSlot.find(row['id']).update_attribute('user_id', row_ids[index])
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
    user_id,
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

end
