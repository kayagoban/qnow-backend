class AddQueueSlotsCountToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :queue_slots_count, :integer, default: 0
  end
end
