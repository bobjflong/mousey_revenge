require 'securerandom'

module MouseyRevenge
  module UUID
    attr_reader :uuid

    def calculate_uuid
      @uuid ||= SecureRandom.uuid
    end
  end
end
