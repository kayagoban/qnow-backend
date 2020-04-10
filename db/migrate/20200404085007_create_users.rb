class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.timestamps null: false
      t.string :session_id, limit: 32
      t.string :name
      t.string :transfer_code, limit: 16
      t.integer :qlength, default: 0
    end
  end
end
