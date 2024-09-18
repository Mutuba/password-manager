# frozen_string_literal: true

# app/models/concerns/unlock_code_validation.rb
module UnlockCodeValidation
  extend ActiveSupport::Concern

  included do
    validate :unlock_code_strength, if: :unlock_code_changed?
  end

  private

  def unlock_code_strength
    return if unlock_code.blank?

    if unlock_code.length < 8
      errors.add(:unlock_code, "must be at least 8 characters long")
      return
    end

    unless unlock_code.chars.any? { |char| ("a".."z").include?(char.downcase) }
      errors.add(:unlock_code, "must contain at least one letter")
    end

    unless unlock_code.chars.any? { |char| ("0".."9").include?(char) }
      errors.add(:unlock_code, "must contain at least one digit")
    end

    special_characters = "!@#$%^&*"
    unless unlock_code.chars.any? { |char| special_characters.include?(char) }
      errors.add(:unlock_code, "must contain at least one special character")
    end
  end
end
