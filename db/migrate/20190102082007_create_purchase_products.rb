class CreatePurchaseProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :purchase_products do |t|
      t.belongs_to :purchase, null: false, fareign_key: true
      t.belongs_to :product,    null: false, fareign_key: true
      t.integer :price,         null: false
      t.integer :num,           null: false, default: 1
      t.integer :total,         null: false

      t.timestamps
    end
  end
end
