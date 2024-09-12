# frozen_string_literal: true

class PasswordValidator < ActiveModel::Validator
  def validate(record)
    password = record.password
    return if password.blank?

    check_lowercase(record, password)
    check_uppercase(record, password)
    check_digit(record, password)
    check_repeating_characters(record, password)
  end

  private

  def check_lowercase(record, password)
    return unless password.chars.none? { |char| ("a".."z").include?(char) }

    record.errors.add(:password, "must contain at least one lowercase letter")
  end

  def check_uppercase(record, password)
    return unless password.chars.none? { |char| ("A".."Z").include?(char) }

    record.errors.add(:password, "must contain at least one uppercase letter")
  end

  def check_digit(record, password)
    return unless password.chars.none? { |char| ("0".."9").include?(char) }

    record.errors.add(:password, "must contain at least one digit")
  end

  def check_repeating_characters(record, password)
    password.chars.each_cons(3) do |a, b, c|
      if a.casecmp?(b) && b.casecmp?(c)
        record.errors.add(:password, "cannot contain three repeating characters in a row")
        break
      end
    end
  end
end
