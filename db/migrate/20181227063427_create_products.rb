class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.string :name,      null: false, index: {unique: true}
      t.integer :price
      t.text :description
      t.boolean :active,   null: false, default: false
      t.integer :sort_no

      t.timestamps
    end
  end
end
