require 'rails_helper'

RSpec.describe "transactions api", type: :request do
  subject { post '/api/v1/transactions', params: params, headers: {merchant_id: merchant_id} }
  let(:body) do
    subject
    JSON.parse(response.body)
  end
  # TODO: is there something like Transaction.last(:uuid)?
  let(:last_uuid) { Transaction.order(id: :desc).limit(1).pluck(:uuid).last }

  shared_examples 'authentication and authorization' do
    context 'when merchant is not authenticated' do
      let(:merchant_id) { nil }

      it { is_expected.to eq(403) }
    end

    context 'when merchant is not active' do
      let(:merchant_id) { create(:merchant, :inactive).id }

      it { is_expected.to eq(401) }
    end
  end

  describe 'authorize' do
    let(:params) { {type: 'authorize', amount: 100.99} }

    include_examples 'authentication and authorization'

    context 'when customer has enough amount' do
      context 'when merchant is authenticated' do
        let(:merchant) { create(:merchant) }
        let(:merchant_id) { merchant.id }

        it { is_expected.to eq(200) }
        it { expect(body).to eq('uuid' => last_uuid) }
        it { expect { subject }.to change { merchant.transactions.authorized.count }.by(1) }
      end
    end
  end

  describe 'charge' do
    let(:params) { {type: 'charge', amount: 100.99} }

    include_examples 'authentication and authorization'

    context 'when customer has correct money held' do
      context 'when merchant is authenticated' do
        let(:merchant) { create(:merchant) }
        let(:merchant_id) { merchant.id }

        before { create(:transaction, :authorized, amount: 100.99) }

        it { is_expected.to eq(200) }
        it { expect(body).to eq('uuid' => last_uuid) }
        it { expect { subject }.to change { merchant.transactions.charged.count }.by(1) }
      end
    end
  end

  describe 'invalid transaction type' do
    let(:params) { {type: SecureRandom.hex, amount: 0.99} }

    context 'when customer has correct money held' do
      context 'when merchant is authenticated' do
        let(:merchant) { create(:merchant) }
        let(:merchant_id) { merchant.id }

        before { create(:transaction, :authorized, amount: 100.99) }

        it { is_expected.to eq(422) }
        it { expect(body).to eq('errors' => {'type' => 'invalid'}) }
      end
    end
  end
end
