require 'rails_helper'

RSpec.describe "stock_items/new", type: :view do
  before(:each) do
    assign(:stock_item, StockItem.new())
  end

  it "renders new stock_item form" do
    render

    assert_select "form[action=?][method=?]", stock_items_path, "post" do
    end
  end
end
