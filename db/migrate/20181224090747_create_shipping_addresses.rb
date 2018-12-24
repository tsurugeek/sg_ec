class CreateShippingAddresses < ActiveRecord::Migration[5.2]
  def change
    create_table :shipping_addresses do |t|
      t.belongs_to :user, null: false, index: {unique: true}, foreign_key: true
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
