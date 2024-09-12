# frozen_string_literal: true

require "rails_helper"

RSpec.describe(PasswordRecordsController, type: :request) do
  let(:user) { create(:user) }
  let(:headers) { valid_headers(user.id) }
  let(:vault) { create(:vault, user: user) }

  describe "#create" do
    context "when user is authenticated" do
      context "with correct params" do
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

      context "when required params are missing" do
        before do
          post vault_password_records_path(vault.id),
            params: { password_record: { name: "First record", username: "Pearl Mutuba" } }.to_json,
            headers: headers
        end

        it "raises errors" do
          expect(response).to(have_http_status(:unprocessable_entity))
          expect(json_response["errors"]).to(include("Password can't be blank"))
        end
      end
    end

    context "when user is not authenticated" do
      before do
        post vault_password_records_path(vault.id),
          params: { password_record: { name: "First record", username: "Pearl Mutuba", password: "Baraka" } }.to_json
      end

      it "raises authentication error" do
        expect(response).to(have_http_status(:unauthorized))
      end
    end
  end

  describe "#update" do
    let(:password_record) { create(:password_record, vault: vault) }

    context "when user is authenticated" do
      context "with correct params" do
        before do
          put password_record_path(password_record.id),
            params: { password_record: { password: "New Password" } }.to_json,
            headers: headers
        end

        it " creates a new password record" do
          expect(response).to(have_http_status(:ok))
          expect(json_response["data"]["attributes"]["password"]).to(eq("New Password"))
        end
      end

      context "when required params are missing" do
        before do
          put password_record_path(password_record.id),
            params: { password_record: { username: "" } }.to_json,
            headers: headers
        end

        it "raises errors" do
          expect(response).to(have_http_status(:unprocessable_entity))
          expect(json_response["errors"]).to(include("Username can't be blank"))
        end
      end
    end

    context "when user is not authenticated" do
      before do
        put password_record_path(password_record.id),
          params: { password_record: { username: "Awesome Username" } }.to_json
      end

      it "raises authentication error" do
        expect(response).to(have_http_status(:unauthorized))
      end
    end
  end

  describe "#destroy" do
    let(:password_record) { create(:password_record, vault: vault) }

    context "when user is authenticated" do
      before { delete password_record_path(password_record.id), headers: }

      it "deletes a password record" do
        expect(response).to(have_http_status(:no_content))
      end
    end

    context "when user is not authenticated" do
      before { delete password_record_path(password_record.id) }

      it "raises authentication error" do
        expect(response).to(have_http_status(:unauthorized))
      end
    end
  end
end
