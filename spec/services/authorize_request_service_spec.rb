# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AuthorizeRequestService, type: :service do
  describe '# call' do
    let(:user) { create(:user) }
    let(:headers) { valid_headers(user.id) }
    let(:nil_token_headers) { invalid_headers }
    let(:expired_token) { expired_headers(user.id) }

    context 'when a user exists' do
      it 'should return a result with user' do
        result = AuthorizeRequestService.call(headers:)
        expect(result.user).not_to be_nil
        expect(result.success?).to eq true
      end
    end

    context 'with nil token' do
      it 'should not return token' do
        result = AuthorizeRequestService.call(headers: nil_token_headers)
        expect(result.user).to be_nil
        expect(result.failure_message).to eq 'Missing authorization header'
        expect(result.success?).to eq false
        expect(result.failure?).to eq true
      end
    end

    context 'with expired token' do
      it 'should raise decode token error' do
        result =  AuthorizeRequestService.call(headers: expired_token)
        
        expect(result.success?).to eq false
        expect(result.failure_message).to eq 'Signature has expired'
        expect(result.user).to be_nil
      end
    end

    context 'when user is not found' do
      before { user.destroy! }
      it 'should raise decode token error' do
        result = AuthorizeRequestService.call(headers:)
        expect(result.user).to be_nil
        expect(result.failure_message).to eq 'Invalid token'
        expect(result.success?).to eq false
        expect(result.failure?).to eq true
      end
    end
  end
end
