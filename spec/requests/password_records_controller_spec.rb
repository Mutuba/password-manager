# frozen_string_literal: true

require "rails_helper"

RSpec.describe(PasswordRecordsController, type: :request) do
  let(:user) { create(:user) }
  let(:headers) { valid_headers(user.id) }
  let(:password_records) { create(:password_record, 5) }

  describe "#index" do
    context "when user is authenticated" do
      before do
        get password_records_path, headers: headers
      end
      it "returns http success" do
        get "/password_records/index"
        expect(response).to(have_http_status(:success))
      end
    end

    context "whenuser is not authenticated" do
      it "returns http success" do
        get "/password_records/index"
        expect(response).to(have_http_status(:success))
      end
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/password_records/create"
      expect(response).to(have_http_status(:success))
    end
  end

  describe "GET /update" do
    it "returns http success" do
      get "/password_records/update"
      expect(response).to(have_http_status(:success))
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/password_records/show"
      expect(response).to(have_http_status(:success))
    end
  end

  describe "GET /destroy" do
    it "returns http success" do
      get "/password_records/destroy"
      expect(response).to(have_http_status(:success))
    end
  end
end
