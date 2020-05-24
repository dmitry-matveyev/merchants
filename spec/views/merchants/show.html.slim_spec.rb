require 'rails_helper'

RSpec.describe "merchants/show", type: :view do
  before(:each) do
    @merchant = assign(:merchant, create(:merchant,
      name: "Name",
      description: "MyText",
      email: "Email",
      total_transaction_sum: "9.99"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/Email/)
    expect(rendered).to match(/Status/)
    expect(rendered).to match(/9.99/)
  end
end
