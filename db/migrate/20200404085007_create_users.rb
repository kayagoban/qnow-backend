class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.timestamps null: false
      t.string :session_id, limit: 32
      t.string :name
      t.integer :qlength
 
    end
  end
end
