class KnownMerchantsClients < ActiveRecord::Migration[6.0]
  def change
    create_table :known_merchant_users, {id: false, force: true} do |t|
      t.integer :client_id, index: true, null: false
      t.integer :merchant_id, null: false
    end
  end
end
