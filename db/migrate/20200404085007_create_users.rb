class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.timestamps null: false
      t.string :email, null: false
      t.string :encrypted_password, limit: 128, null: false
      t.string :confirmation_token, limit: 128
      t.string :remember_token, limit: 128, null: false
      t.string :type
      t.string :name
      t.string :phone
    end

    add_index :users, :email
    add_index :users, :remember_token


    create_table :merchants do |t|
      t.timestamps null: false
      t.string :email, null: false
      t.string :encrypted_password, limit: 128, null: false
      t.string :confirmation_token, limit: 128
      t.string :remember_token, limit: 128, null: false
      t.string :type
      t.string :name
      t.string :phone
      t.integer :qlength
    end

    add_index :merchants, :email
    add_index :merchants, :remember_token
 
  end
end
