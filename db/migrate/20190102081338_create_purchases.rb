class CreatePurchases < ActiveRecord::Migration[5.2]
  def change
    create_table :purchases do |t|
      t.belongs_to :user
      t.string :type,                    null: false
      t.integer :state,                  null: false
      t.datetime :purchased_at
      t.datetime :delivered_at
      t.integer :subtotal
      t.integer :products_num,           null: false, default: 0
      t.integer :shipping_cost
      t.integer :cod_fee
      t.integer :consumption_tax_rate
      t.integer :consumption_tax
      t.integer :total

      t.date :delivery_scheduled_date
      t.time :delivery_scheduled_time_start
      t.time :delivery_scheduled_time_end

      t.boolean :ref_shipping_address
      t.boolean :save_shipping_address,  null: false, default: true

      t.integer :lock_version,           null: false, default: 0
      t.timestamps
    end
    add_index :purchases, [:user_id, :type]
  end
end
