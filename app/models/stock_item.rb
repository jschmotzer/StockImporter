class StockItem < ActiveRecord::Base
  include Models

  self.primary_key = :id

  serialize(:modifiers, Array)

  def self.map_columns
    {
      'item id' => 'id', 
      'description' => 'description',
      'price' => 'price',
      'cost' => 'cost', 
      'price_type' => 'price_type', 
      'quantity_on_hand' => 'quantity_on_hand',
      'modifiers' => 'modifiers'
    }
  end
end
