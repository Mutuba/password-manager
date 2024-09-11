# frozen_string_literal: true

require "rails_helper"

RSpec.describe(AuthenticationController, type: :request) do
  let(:user) { create(:user) }
  let(:valid_params) { { username: user.username, password: user.password } }
  let(:invalid_params) { { username: user.username, password: "random_password" } }

  describe "authentication" do
    context "when valid credentials" do
      before do
        post login_path, params: { user: valid_params }.to_json, headers: { "Content-Type": "application/json" }
      end

      it "should return a user token" do
        expect(json_response["auth_token"]).not_to(be_nil)
      end
    end

    context "when invalid credentials" do
      before do
        post login_path, params: { user: invalid_params }.to_json, headers: { "Content-Type": "application/json" }
      end
      it "should return a user token" do
        expect(json_response["error"]).to(eq("Invalid credentials"))
        expect(response).to(have_http_status(401))
      end
    end
  end
end
