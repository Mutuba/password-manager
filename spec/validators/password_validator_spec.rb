

# frozen_string_literal: true

require "rails_helper"

RSpec.describe(PasswordValidator, type: :model) do
  let(:password_record) { PasswordRecord.new(name: "John Doe", username: "Awesome Username", password: password) }

  context "when the password is valid" do
    let(:password) { "QPFJWz1343439" }

    it "does not add any errors" do
      password_record.valid?
      expect(password_record.errors[:password]).to(be_empty)
    end
  end

  context "when the password is missing a lowercase letter" do
    let(:password) { "VALID123" }

    it "adds a lowercase error" do
      password_record.valid?
      expect(password_record.errors[:password]).to(include("must contain at least one lowercase letter"))
    end
  end

  context "when the password is missing an uppercase letter" do
    let(:password) { "valid123" }

    it "adds an uppercase error" do
      password_record.valid?
      expect(password_record.errors[:password]).to(include("must contain at least one uppercase letter"))
    end
  end

  context "when the password is missing a digit" do
    let(:password) { "ValidPassword" }

    it "adds a digit error" do
      password_record.valid?
      expect(password_record.errors[:password]).to(include("must contain at least one digit"))
    end
  end

  context "when the password has three repeating characters in a row" do
    let(:password) { "Valid111" }

    it "adds a repeating characters error" do
      password_record.valid?
      expect(password_record.errors[:password]).to(include("cannot contain three repeating characters in a row"))
    end
  end

  context "when the password is blank" do
    let(:password) { "" }

    it "adds blank errors" do
      password_record.valid?
      expect(password_record.errors[:password]).to(include("can't be blank", "is too short (minimum is 10 characters)"))
    end
  end
end
