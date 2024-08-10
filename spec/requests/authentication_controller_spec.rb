# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AuthenticationController, type: :request do
  let(:user) { create(:user) }
  let(:params) { { username: user.username, password: user.password } }
  let(:invalid_params) { { username: user.username, password: 'random_password' } }

  describe 'authentication' do
    context 'when valid credentials' do
      before { post login_path, params: }
      it 'should return a user token' do
        expect(json_response['auth_token']).not_to be_nil
      end
    end

    context 'when invalid credentials' do
      before { post login_path, params: invalid_params }
      it 'should return a user token' do
        expect(json_response['error']).to eq 'Invalid credentials'
        expect(response).to have_http_status(401)
      end
    end
  end
end
