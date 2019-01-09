class CreateShippingAddresses < ActiveRecord::Migration[5.2]
  def change
    create_table :shipping_addresses do |t|
      t.references :shippable, polymorphic: true, null: false
      t.string :name
      t.string :postal_code
      t.string :prefecture
      t.string :city
      t.string :address
      t.string :building

      t.timestamps
    end
  end
end
