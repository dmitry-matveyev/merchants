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

    context 'when merchant is authenticated' do
      context 'when customer has correct money held' do
        let(:merchant) { create(:merchant) }
        let(:merchant_id) { merchant.id }
        let(:authorized_transaction) { create(:transaction, :authorized, merchant: merchant, amount: 100.99) }

        # There can be another approach to seach if any valid authorized transaction exists
        # with the same amount and merchant
        # instead of requiring merchant software to send auth transaction id
        # but it should anyway be able to send it for refund transaction
        # so I assume it can do this in general
        let(:params) { {type: 'charge', amount: 100.99, transaction_id: authorized_transaction.id} }

        it { is_expected.to eq(200) }
        it { expect(body).to eq('uuid' => last_uuid) }
        it { expect { subject }.to change { merchant.transactions.charged.count }.by(1) }
      end

      context 'when customer has no hold transaction' do
        let(:merchant) { create(:merchant) }
        let(:merchant_id) { merchant.id }

        it { is_expected.to eq(422) }
        it { expect(body).to eq('errors' => {'transaction_id' => 'invalid'}) }
        it { expect { subject }.not_to change { Transaction.charged.count } }
      end

      context 'when hold transaction has invalid amount' do
        let(:merchant) { create(:merchant) }
        let(:merchant_id) { merchant.id }
        let(:authorized_transaction) { create(:transaction, :authorized, merchant: merchant, amount: 1.12) }

        let(:params) { {type: 'charge', amount: 100.99, transaction_id: authorized_transaction.id} }

        it { is_expected.to eq(422) }
        it { expect(body).to eq('errors' => {'transaction_id' => 'invalid'}) }
        it { expect { subject }.not_to change { Transaction.charged.count } }
      end

      context 'when hold transaction has invalid status' do
        let(:merchant) { create(:merchant) }
        let(:merchant_id) { merchant.id }
        let(:authorized_transaction) { create(:transaction, :authorized, 
          status: Transaction.statuses[:reversed], merchant: merchant, amount: 100.99) }

        let(:params) { {type: 'charge', amount: 100.99, transaction_id: authorized_transaction.id} }

        it { is_expected.to eq(422) }
        it { expect(body).to eq('errors' => {'transaction_id' => 'invalid'}) }
        it { expect { subject }.not_to change { Transaction.charged.count } }
      end

      context 'when hold transaction exists for another merchant' do
        let(:merchant) { create(:merchant) }
        let(:merchant_id) { merchant.id }
        let(:authorized_transaction) { create(:transaction, :authorized, amount: 100.99) }

        let(:params) { {type: 'charge', amount: 100.99, transaction_id: authorized_transaction.id} }

        it { is_expected.to eq(422) }
        it { expect(body).to eq('errors' => {'transaction_id' => 'invalid'}) }
        it { expect { subject }.not_to change { Transaction.charged.count } }
      end
    end
  end

  describe 'refund' do
    let(:params) { {type: 'refund', amount: 100.99} }

    include_examples 'authentication and authorization'

    context 'when merchant is authenticated' do
      context 'when customer has corresponding charge transaction' do
        let(:merchant) { create(:merchant) }
        let(:merchant_id) { merchant.id }
        let(:charged_transaction) { create(:transaction, :charged, merchant: merchant, amount: 100.99) }

        let(:params) { {type: 'refund', amount: 100.99, transaction_id: charged_transaction.id} }

        it { is_expected.to eq(200) }
        it { expect(body).to eq('uuid' => last_uuid) }
        it { expect { subject }.to change { merchant.transactions.refunded.count }.by(1) }
        it { expect { subject }.to change { charged_transaction.reload.status }.to('reversed') }
      end

      context 'when customer has no charged transaction' do
        let(:merchant) { create(:merchant) }
        let(:merchant_id) { merchant.id }

        it { is_expected.to eq(422) }
        it { expect(body).to eq('errors' => {'transaction_id' => 'invalid'}) }
        it { expect { subject }.not_to change { Transaction.refunded.count } }
      end

      context 'when charged transaction has invalid status'
      context 'when charged transaction exists for another merchant'
    end
  end

  describe 'invalid transaction type' do
    let(:params) { {type: SecureRandom.hex, amount: 0.99} }

    context 'when merchant is authenticated' do
      let(:merchant) { create(:merchant) }
      let(:merchant_id) { merchant.id }

      before { create(:transaction, :authorized, amount: 100.99) }

      it { is_expected.to eq(422) }
      it { expect(body).to eq('errors' => {'type' => 'invalid'}) }
      it { expect { subject }.not_to change { Transaction.count } }
    end
  end
end
