# frozen_string_literal: true

require "rails_helper"

RSpec.describe PasswordRecordsController, type: :request do
  let(:user) { create(:user) }
  let(:headers) { valid_headers(user.id) }
  let(:vault_password) { "FavouritePassword123!*" }
  let(:vault) { create(:vault, user: user, unlock_code: vault_password) }
  let(:password_record) { build(:password_record, vault: vault) }

  shared_context "with authenticated user and encryption setup" do
    before do
      password_record.encryption_key(vault_password)
      password_record.save!
    end
  end

  shared_context "with unauthenticated user" do
    before do
      password_record.encryption_key(vault_password)
      password_record.save!
    end
  end

  describe "#create" do
    context "when user is authenticated" do
      context "with correct params" do
        before do
          post vault_password_records_path(vault.id),
            params: {
              vault_password: vault_password,
              password_record: {
                name: "First record",
                username: "Pearl Mutuba",
                password: "QPFJWz1343439",
              },
            }.to_json,
            headers: headers
        end

        it "creates a new password record" do
          expect(response).to have_http_status(:created)
          expect(json_response["data"]["attributes"]["name"]).to eq("First record")
        end
      end

      context "when required params are missing" do
        before do
          post vault_password_records_path(vault.id),
            params: {
              vault_password: vault_password,
              password_record: { name: "First record", username: "Pearl Mutuba" },
            }.to_json,
            headers: headers
        end

        it "raises errors" do
          expect(response).to have_http_status(:unprocessable_entity)
          expect(json_response["errors"]).to include("Password can't be blank")
        end
      end
    end

    context "when user is not authenticated" do
      before do
        post vault_password_records_path(vault.id),
          params: {
            vault_password: vault_password,
            password_record: {
              name: "First record",
              username: "Pearl Mutuba",
              password: "QPFJWz1343439",
            },
          }.to_json
      end

      it "raises authentication error" do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "#update" do
    include_context "with authenticated user and encryption setup"

    context "with correct params" do
      before do
        put vault_password_record_path(vault.id, password_record.id),
          params: {
            vault_password: vault_password,
            password_record: { password: "QPFJWz13434398" },
          }.to_json,
          headers: headers
      end

      it "updates the password record" do
        expect(response).to have_http_status(:ok)
      end
    end

    context "when required params are missing" do
      before do
        put vault_password_record_path(vault.id, password_record.id),
          params: { vault_password: vault_password, password_record: { username: "" } }.to_json,
          headers: headers
      end

      it "raises errors" do
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response["errors"]).to include("Username can't be blank")
      end
    end

    context "when user is not authenticated" do
      include_context "with unauthenticated user"

      before do
        put vault_password_record_path(vault.id, password_record.id),
          params: {
            vault_password: vault_password,
            password_record: { username: "Awesome Username" },
          }.to_json
      end

      it "raises authentication error" do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "#destroy" do
    include_context "with authenticated user and encryption setup"

    context "when user is authenticated" do
      before do
        delete password_record_path(password_record.id), headers: headers
      end

      it "deletes the password record" do
        expect(response).to have_http_status(:no_content)
      end
    end

    context "when user is not authenticated" do
      before do
        delete password_record_path(password_record.id)
      end

      it "raises authentication error" do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
