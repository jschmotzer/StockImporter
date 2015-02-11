json.array!(@stock_items) do |stock_item|
  json.extract! stock_item, :id
  json.url stock_item_url(stock_item, format: :json)
end
