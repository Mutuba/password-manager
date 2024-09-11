# frozen_string_literal: true

require "rails_helper"

RSpec.describe(AuthenticateUserService) do
  describe "# call" do
    let(:user) { create(:user) }

    context "when a user exists" do
      it "should return a user token" do
        result = AuthenticateUserService.call(username: user.username, password: user.password)

        expect(result[:auth_token]).not_to(be_nil)
        expect(result.success?).to(eq(true))
      end
    end

    context "with incorrect password" do
      it "should not return token" do
        result = AuthenticateUserService.call(username: user.username, password: "random password")

        expect(result.auth_token).to(be_nil)
        expect(result.success?).to(eq(false))
        expect(result.failure?).to(eq(true))
      end
    end
  end
end
