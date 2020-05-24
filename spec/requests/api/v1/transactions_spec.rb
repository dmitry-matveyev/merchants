require 'rails_helper'

RSpec.describe "transactions api", type: :request do
  subject { post '/api/v1/transactions', params: params, headers: {merchant_id: merchant_id} }

  describe 'authorize' do
    let(:params) { {type: 'authorize', amount: 100.99} }
    let(:body) do
      subject
      JSON.parse(response.body)
    end
    let(:last_uuid) { Transaction.authorized.last.uuid }

    context 'when customer has enough amount' do
      context 'when merchant is authenticated' do
        let(:merchant_id) { create(:merchant).id }

        it { is_expected.to eq(200) }
        it { expect(body).to eq('uuid' => last_uuid) }
      end
    end
  end
end
