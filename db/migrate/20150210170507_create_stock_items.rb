class CreateStockItems < ActiveRecord::Migration
  def up
    create_table :stock_items, id: false do |t|
      t.integer :id, null: false
      t.string :description
      t.string :price
      t.string :cost
      t.string :price_type
      t.integer :quantity_on_hand
      t.text :modifiers

      t.timestamps
    end
  end

  def down
    drop_table :stock_items
  end
end