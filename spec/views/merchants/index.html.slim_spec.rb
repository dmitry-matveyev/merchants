require 'rails_helper'

RSpec.describe "merchants/index", type: :view do
  before(:each) do
    assign(:merchants, [
      create(:merchant,
        name: "Name",
        description: "MyText",
        email: "Email",
        status: :active,
        total_transaction_sum: "9.99"
      ),
      create(:merchant,
        name: "Name",
        description: "MyText",
        email: "Email",
        status: :inactive,
        total_transaction_sum: "9.99"
      )
    ])
  end

  it "renders a list of merchants" do
    render
    assert_select "tr>td", text: "Name".to_s, count: 2
    assert_select "tr>td", text: "MyText".to_s, count: 2
    assert_select "tr>td", text: "Email".to_s, count: 2
    assert_select "tr>td", text: 'active', count: 1
    assert_select "tr>td", text: 'inactive', count: 1
    assert_select "tr>td", text: "9.99".to_s, count: 2
  end
end
