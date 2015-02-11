require 'rails_helper'

RSpec.describe "stock_items/show", type: :view do
  before(:each) do
    @stock_item = assign(:stock_item, StockItem.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
