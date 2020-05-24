require 'rails_helper'

RSpec.describe "merchants/new", type: :view do
  let(:merchant) { build(:merchant) }
  before { assign(:merchant, merchant) }

  it "renders new merchant form" do
    render

    assert_select "form[action=?][method=?]", merchants_path, "post" do

      assert_select "input[name=?]", "merchant[name]"

      assert_select "textarea[name=?]", "merchant[description]"

      assert_select "input[name=?]", "merchant[email]"

      assert_select "select[name=?]", "merchant[status]"

      assert_select "input[name=?]", "merchant[total_transaction_sum]"
    end
  end
end
