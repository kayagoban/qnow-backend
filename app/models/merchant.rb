class Merchant < ApplicationRecord
  require 'pry'

  class BootException < Exception; end

  include Clearance::User

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

    target_user_id = rows.first['user_id']

    ActiveRecord::Base.transaction do
      rows.reverse.each do |row|
        moved_user_id = row['user_id']
        QueueSlot.where(id: row['id']).update(user_id: target_user_id)
        target_user_id = moved_user_id
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
