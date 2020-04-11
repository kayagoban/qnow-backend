class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.timestamps null: false
      t.string :join_code, limit: 16
      t.string :transfer_code, limit: 16
      t.string :name, default: ""
      t.integer :qlength, default: 0
      t.integer :queue_slots_count, default: 0
    end

    add_index :users, :join_code
    add_index :users, :transfer_code
  end
end
