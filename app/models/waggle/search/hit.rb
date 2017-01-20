module Waggle
  module Search
    class Hit
      attr_reader :adapter_hit
      private :adapter_hit

      delegate :name, :at_id, :part_parent, :type, :description, :short_description, :date_created, :creator, :thumbnail_url, :last_updated, to: :adapter_hit

      def initialize(adapter_hit)
        @adapter_hit = adapter_hit
      end
    end
  end
end
