# frozen_string_literal: true

Rails.application.config.filter_parameters += [
  :password, :secret, :token, :_key, :crypt, :salt, :certificate, :otp, :ssn, :encrypted_password, :unlock_code,
]
