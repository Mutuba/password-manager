# frozen_string_literal: true

class ApplicationService
  class << self
    def call(**params)
      new(**params).call
    end
  end
  private_class_method :new
end
