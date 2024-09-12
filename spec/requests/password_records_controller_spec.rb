# frozen_string_literal: true

require "rails_helper"

RSpec.describe(PasswordRecordsController, type: :request) do
  let(:user) { create(:user) }
  let(:headers) { valid_headers(user.id) }
  let(:vault) { create(:vault, user: user) }
  let(:password_record) { create(:password_record, vault: vault) }

  describe "#create" do
    context "when user is authenticated" do
      before do
        post vault_password_records_path(vault.id),
          params: { password_record: { name: "First record", username: "Pearl Mutuba", password: "Baraka" } }.to_json,
          headers: headers
      end

      it " creates a new password record" do
        expect(response).to(have_http_status(:created))
        expect(json_response["data"]["attributes"]["name"]).to(eq("First record"))
      end
    end

    context "when user is not authenticated" do
      it "raises authentication error" do
      end
    end

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

  describe "GET /destroy" do
    it "returns http success" do
      get "/password_records/destroy"
      expect(response).to(have_http_status(:success))
    end
  end
end
