module Waggle
  module Search
    class Query
      DEFAULT_ROWS = 12

      attr_reader :q, :facets, :sort, :rows, :start, :filters

      def initialize(q:, facets: nil, sort: nil, rows: nil, start: nil, filters: {})
        @q = q
        @facets = facets || {}
        @sort = sort
        @rows = (rows || DEFAULT_ROWS).to_i
        @start = (start || 0).to_i
        @filters = filters
      end

      def configuration
        Waggle.configuration
      end

      def facet(name)
        facets[name]
      end

      def sort_field
        if sort.present?
          configuration.sort(sort.split(" ")[0].to_sym)
        end
      end

      def sort_direction
        if sort.present?
          sortArr = sort.split(" ")
          return sortArr.length >= 2 ? sortArr[1] : "desc"
        end
      end

      def result
        @result ||= Waggle::Search::Result.new(query: self)
      end
    end
  end
end
