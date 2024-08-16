# frozen_string_literal: true

require 'rails_helper'

RSpec.describe VaultsController, type: :request do
  let(:user) { create(:user) }
  let(:headers) { valid_headers(user.id) }

  describe '#create' do
    context 'when user is authenticated' do
      before { post vaults_path, params: { vault: { name: 'Iconic vault' } }.to_json, headers: }
      before do
        # post vaults_path, params: { vault: { name: 'Iconic vault' } }.to_json, headers: { 'Authorization' => token_generator(user.id), 'Content-Type' => 'application/json' }
      end

      it 'creates a new vault' do
        expect(response).to have_http_status(:created)
        expect(json['name']).to eq('Iconic vault')
      end
    end
  end
end
