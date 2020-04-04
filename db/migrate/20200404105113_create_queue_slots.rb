class CreateQueueSlots < ActiveRecord::Migration[6.0]
  def change
    create_table :queue_slots do |t|
      t.references :users, null: false, foreign_key: true, index: true
      t.references :merchants, null: false, foreign_key: true

      t.timestamps
    end
  end
end
