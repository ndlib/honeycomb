require "securerandom"

module Metadata
  class GenerateUniqueKey
    def self.call
      new.generate!
    end

    def generate!
      SecureRandom.uuid
    end
  end
end
