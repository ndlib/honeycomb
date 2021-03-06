module Waggle
  module Search
    class Query
      DEFAULT_ROWS = 12

      attr_reader :q, :facets, :sort, :rows, :start, :filters, :group_by

      def initialize(q:, facets: nil, sort: nil, rows: nil, start: nil, filters: {}, group_by: nil)
        @q = q
        @facets = facets || {}
        @sort = sort
        @rows = (rows || DEFAULT_ROWS).to_i
        @start = (start || 0).to_i
        @filters = filters
        @group_by = group_by
      end

      def configuration
        Waggle.configuration
      end

      def facet(name)
        facets[name]
      end

      def sort_field
        if sort.present?
          sort_sym = sort.split(" ")[0].to_sym
          sort_field = configuration.sort(sort_sym)
          return sort_field.field_name if sort_field.present?
          sort_sym
        end
      end

      def sort_direction
        if sort.present?
          sort_arr = sort.split(" ")
          if sort_arr.length == 1
            sort_field = configuration.sort(sort_arr[0].to_sym)
            return get_valid_sort_direction(sort_field.direction) if sort_field.present?
          end
          get_valid_sort_direction(sort_arr[1])
        end
      end

      def get_valid_sort_direction(direction)
        return "desc" if direction != "desc" && direction != "asc"
        direction
      end

      def result
        @result ||= Waggle::Search::Result.new(query: self)
      end
    end
  end
end
