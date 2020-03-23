module Waggle
  module Adapters
    module Solr
      def self.session
        @session ||= self::Session.new
      end

      def self.index(*objects)
        session.index(*objects)
      end

      def self.index!(*objects)
        session.index!(*objects)
      end

      def self.remove(*objects)
        session.remove(*objects)
      end

      def self.remove!(*objects)
        session.remove!(*objects)
      end

      def self.remove_all()
        session.remove_all()
      end

      def self.commit
        session.commit
      end

      def self.search_result(query)
        self::Search::Result.new(query)
      end
    end
  end
end
