class CreateShippingAddresses < ActiveRecord::Migration[5.2]
  def change
    create_table :shipping_addresses do |t|
      t.integer :shippable_id, null: false
      t.string :shippable_type, null: false
      t.string :name
      t.string :postal_code
      t.string :prefecture
      t.string :city
      t.string :address
      t.string :building

      t.timestamps
    end
    add_index :shipping_addresses, [:shippable_type, :shippable_id]
  end
end
