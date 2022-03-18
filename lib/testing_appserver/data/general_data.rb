# frozen_string_literal: true

module TestingAppServer
  # General AppServer data
  class GeneralData
    def self.generate_random_name(pattern)
      "#{pattern}_#{SecureRandom.hex(5)}"
    end
  end
end
