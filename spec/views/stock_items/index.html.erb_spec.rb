require 'rails_helper'

RSpec.describe "stock_items/index", type: :view do
  before(:each) do
    assign(:stock_items, [
      StockItem.create!(),
      StockItem.create!()
    ])
  end

  it "renders a list of stock_items" do
    render
  end
end
