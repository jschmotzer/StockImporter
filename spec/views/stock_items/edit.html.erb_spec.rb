require 'rails_helper'

RSpec.describe "stock_items/edit", type: :view do
  before(:each) do
    @stock_item = assign(:stock_item, StockItem.create!())
  end

  it "renders the edit stock_item form" do
    render

    assert_select "form[action=?][method=?]", stock_item_path(@stock_item), "post" do
    end
  end
end
