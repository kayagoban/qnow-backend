class CreateQueueSlots < ActiveRecord::Migration[6.0]
  def change
    create_table :queue_slots, force: true do |t|
      t.integer :merchant_id, null: false, index: true
      t.integer :client_id, null: false, index: true
      t.boolean :booted, default: false
      t.timestamps
    end

  end
end
