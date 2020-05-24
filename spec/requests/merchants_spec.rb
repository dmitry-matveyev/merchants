 require 'rails_helper'

RSpec.describe "/merchants", type: :request do
  # Merchant. As you add validations to Merchant, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  describe "GET /index" do
    it "renders a successful response" do
      Merchant.create! valid_attributes
      get merchants_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      merchant = Merchant.create! valid_attributes
      get merchant_url(merchant)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_merchant_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "render a successful response" do
      merchant = Merchant.create! valid_attributes
      get edit_merchant_url(merchant)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Merchant" do
        expect {
          post merchants_url, params: { merchant: valid_attributes }
        }.to change(Merchant, :count).by(1)
      end

      it "redirects to the created merchant" do
        post merchants_url, params: { merchant: valid_attributes }
        expect(response).to redirect_to(merchant_url(Merchant.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Merchant" do
        expect {
          post merchants_url, params: { merchant: invalid_attributes }
        }.to change(Merchant, :count).by(0)
      end

      it "renders a successful response (i.e. to display the 'new' template)" do
        post merchants_url, params: { merchant: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested merchant" do
        merchant = Merchant.create! valid_attributes
        patch merchant_url(merchant), params: { merchant: new_attributes }
        merchant.reload
        skip("Add assertions for updated state")
      end

      it "redirects to the merchant" do
        merchant = Merchant.create! valid_attributes
        patch merchant_url(merchant), params: { merchant: new_attributes }
        merchant.reload
        expect(response).to redirect_to(merchant_url(merchant))
      end
    end

    context "with invalid parameters" do
      it "renders a successful response (i.e. to display the 'edit' template)" do
        merchant = Merchant.create! valid_attributes
        patch merchant_url(merchant), params: { merchant: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested merchant" do
      merchant = Merchant.create! valid_attributes
      expect {
        delete merchant_url(merchant)
      }.to change(Merchant, :count).by(-1)
    end

    it "redirects to the merchants list" do
      merchant = Merchant.create! valid_attributes
      delete merchant_url(merchant)
      expect(response).to redirect_to(merchants_url)
    end
  end
end
