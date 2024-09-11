# frozen_string_literal: true

require "rails_helper"

RSpec.describe(VaultsController, type: :request) do
  let(:user) { create(:user) }
  let(:headers) { valid_headers(user.id) }

  describe "#create" do
    context "when user is authenticated" do
      before do
        post vaults_path,
          params: { vault: { name: "Iconic vault", unlock_code: "Favouritepassword123!" } }.to_json,
          headers:
      end

      it "creates a new vault" do
        expect(response).to(have_http_status(:created))
        expect(json_response["name"]).to(eq("Iconic vault"))
      end
    end

    context "when user is not authenticated" do
      before do
        post vaults_path,
          params: { vault: { name: "Iconic vault", unlock_code: "Favouritepassword123!" } }.to_json
      end
      it "raises authentication error" do
        expect(response).to(have_http_status(:unauthorized))
        expect(json_response["error"]).to(eq("Missing authorization header"))
      end
    end
    context "when password does not meet the requirements" do
      before do
        post vaults_path,
          params: { vault: { name: "Game of Thrones", unlock_code: "tooshort" } }.to_json,
          headers:
      end

      it "raises validation error" do
        expect(response).to(have_http_status(:unprocessable_entity))
        expect(json_response["errors"]).to(include("Unlock code is weak"))
      end
    end
  end

  describe "#show" do
    let(:valid_password) { "FavouritePassword123!" }
    let!(:vault) do
      create(:vault, :with_password_records, name: "Special Vault", user: user, unlock_code: valid_password)
    end
    context "when authenticated" do
      context "when active session" do
        before do
          allow(REDIS).to(receive(:exists?).with(any_args).and_return(1))
          get vault_path(vault.id), headers:
        end
        it "returns the vault" do
          expect(response).to(have_http_status(:ok))
          expect(json_response["name"]).to(eq("Special Vault"))
        end
      end

      context "when session is expired" do
        before do
          allow(REDIS).to(receive(:exists?).with(any_args).and_return(0))
          get vault_path(vault.id), headers:
        end

        it "returns expired session error" do
          expect(response).to(have_http_status(:unauthorized))
          expect(json_response["error"]).to(eq("Vault session expired"))
        end
      end
    end

    context "when not authenticated" do
      before do
        get vault_path(vault.id)
        it "raises authentication error" do
          expect(response).to(have_http_status(:unauthorized))
          expect(json_response["error"]).to(eq("Missing authorization header"))
        end
      end
    end
  end

  describe "#update" do
    let(:valid_password) { "FavouritePassword123!" }
    let!(:vault) do
      create(:vault, name: "Special Vault", user: user, unlock_code: valid_password)
    end
    context "when authenticated" do
      before do
        put vault_path(vault.id), params: { vault: { name: "Updated vault name" } }.to_json, headers: headers
      end

      it "updates the vault" do
        expect(response).to(have_http_status(:ok))
        expect(json_response["name"]).to(eq("Updated vault name"))
      end
    end

    context "when not authenticated" do
      before do
        put vault_path(vault.id), params: { vault: { name: "Updated vault name" } }.to_json
      end
      it "raises authentication error" do
        expect(response).to(have_http_status(:unauthorized))
        expect(json_response["error"]).to(eq("Missing authorization header"))
      end
    end
  end

  describe "#destroy" do
    let(:valid_password) { "FavouritePassword123!" }
    let!(:vault) do
      create(:vault, name: "Special Vault", user: user, unlock_code: valid_password)
    end
    context "when authenticated" do
      before do
        delete vault_path(vault.id), headers:
      end

      it "successfully deletes a vault" do
        expect(response).to(have_http_status(204))
      end
    end

    context "when not authenticated" do
      before do
        delete vault_path(vault.id)
      end

      it "raises authentication error" do
        expect(response).to(have_http_status(:unauthorized))
      end
    end
  end

  describe "#login" do
    let(:valid_password) { "FavouritePassword123!" }
    let!(:vault) { create(:vault, user:, unlock_code: valid_password) }
    let(:headers) { valid_headers(user.id) }

    context "when correct password" do
      before do
        allow(REDIS).to(receive(:setex))
        post vault_login_path(vault.id),
          params: { vault: { unlock_code: "FavouritePassword123!" } }.to_json,
          headers:
      end

      it "logs in" do
        expect(response).to(have_http_status(:success))
        expect(json_response["message"]).to(eq("Login successful"))
        expect(REDIS).to(have_received(:setex))
      end
    end

    context "when wrong password" do
      before do
        post vault_login_path(vault.id),
          params: { vault: { unlock_code: "Password1234" } }.to_json,
          headers:
      end

      it "does not login in" do
        expect(response).to(have_http_status(:unauthorized))
        expect(json_response["error"]).to(eq("Invalid password"))
      end
    end
  end

  describe "#logout" do
    let(:valid_password) { "FavouritePassword123!" }
    let!(:vault) { create(:vault, user:, unlock_code: valid_password) }
    let(:headers) { valid_headers(user.id) }

    context "when there is a vault session" do
      before do
        allow(REDIS).to(receive(:exists?).with(any_args).and_return(1))
        post vault_logout_path(vault.id), headers:
      end

      it "logs out" do
        expect(response).to(have_http_status(:success))
        expect(json_response["message"]).to(eq("Logout successful"))
      end
    end

    context "when there is no session" do
      before do
        allow(REDIS).to(receive(:exists?).with(any_args).and_return(0))
        post vault_logout_path(vault.id), headers:
      end

      it "does nothing" do
        expect(response).to(have_http_status(:unprocessable_entity))
        expect(json_response["error"]).to(eq("No active session found"))
      end
    end
  end
end
