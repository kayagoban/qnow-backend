class KnownMerchantsClients < ActiveRecord::Migration[6.0]
  def change
    create_table :known_merchant_users, {force: true} do |t|
      t.integer :client_id, index: true, null: false
      t.integer :merchant_id, index: true, null: false
      t.integer :position
    end
  end
end
