module Waggle
  module Search
    class Hit
      attr_reader :adapter_hit
      private :adapter_hit

      delegate :name, :at_id, :type, :description, :date_created, :creator, :thumbnail_url, :last_updated, to: :adapter_hit

      def initialize(adapter_hit)
        @adapter_hit = adapter_hit
      end

      def short_description
        "#{creator} #{date_created}"
      end

    end
  end
end
