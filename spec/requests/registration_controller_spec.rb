# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AuthenticationController, type: :request do
  let(:user) { create(:user) }
  let(:params) { { user: attributes_for(:user) } }
  let(:invalid_params) { { user: { username: 'Mr Bean', password: 'random_password' } } }

  describe 'Registration' do
    context 'when valid sign up credentials' do
      before { post sign_up_path, params: }
      it 'should create a user and return a user token' do
        expect(json_response['auth_token']).not_to be_nil
        expect(response).to have_http_status(201)
      end
    end

    context 'when invalid sign up credentials' do
      before { post sign_up_path, params: invalid_params }
      it 'should return errors' do
        expect(json_response['error']).to eq "Validation failed: Email can't be blank, Email is invalid"
        expect(response).to have_http_status(422)
      end
    end
  end
end
