class CreateQueueSlots < ActiveRecord::Migration[6.0]
  def change
    create_table :queue_slots do |t|
      t.references :user, null: false, foreign_key: true, index: true
      t.references :merchant, null: false, foreign_key: true, index: false
      #t.timestamps
    end
  end
end
