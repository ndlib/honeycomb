module Waggle
  module Adapters
    module Solr
      module Search
        class Result
          attr_reader :query

          def initialize(query: query)
            @query = query
          end

          def hits
            @hits ||= solr_docs.map { |solr_doc| Waggle::Adapters::Solr::Search::Hit.new(solr_doc) }
          end

          def facets
            if @facets.nil?
              @facets = configuration.facets.map do |facet|
                facet_rows = solr_facet(facet.name)
                if facet_rows.present?
                  Waggle::Adapters::Solr::Search::Facet.new(facet_config: facet, facet_rows: facet_rows)
                end
              end
              @facets.compact!
            end
            @facets
          end

          def page
            (query.start / per_page) + 1
          end

          def per_page
            query.rows
          end

          def total
            solr_response.fetch("numFound", 0)
          end

          def result
            if !@result
              @result ||= connection.paginate(
                page,
                per_page,
                "select",
                params: solr_params,
              )

              @numResultsForRequestedTags ||= connection.paginate(
                page,
                0,
                "select",
                params: solr_params(false)
              )
              concatFacets
            end

            @result
          end

          private

          # There are cases where the facets marked by the user are not returned with a count
          # This function adds those counts back into the final list of facets returned
          def concatFacets
            queryCounts = @result["facet_counts"]["facet_fields"]
            requestedCounts = @numResultsForRequestedTags["facet_counts"]["facet_fields"]

            requestedCounts.each do |facet, tags|
              tags.each_slice(2) { |tagWithVal|
                # Since these are arrays, we'll only append the values ([tag, val]) if they're not present
                if !queryCounts[facet].include? tagWithVal[0]
                  queryCounts[facet] += tagWithVal
                end
              }
            end
          end

          def solr_params(getOtherTags = true)
            {
              q: query.q,
              fl: "score *",
              qf: solr_query_fields,
              pf: solr_phrase_fields,
              fq: solr_filters(getOtherTags),
              sort: solr_sort,
              facet: true,
              defType: "edismax",
              :"facet.field" => facet_fields,
              mm: 1,
            }.merge(facet_limits)
          end

          def solr_query_fields
            fields = []
            fields_with_boost.each do |field|
              [:unstem_search, :t].each do |suffix|
                fields << "#{field.name}_#{suffix}^#{field.boost}"
              end
            end
            fields << "text"
            fields << "text_unstem_search"
            fields.join " "
          end

          def solr_phrase_fields
            solr_query_fields
          end

          def fields_with_boost
            query.configuration.fields.select { |field| field.boost.present? && field.boost != 1 }
          end

          def facet_fields
            configuration.facets.map do |facet|
              field = "#{facet.name}_facet"
              "{!ex=#{field}}#{field}"
            end
          end

          def facet_limits
            result = {}
            configuration.facets.each do |facet|
              result[:"f.#{facet.name}_facet.facet.limit"] = facet.limit if facet.limit.present?
            end
            result
          end

          def solr_sort
            if sort_field
              "#{sort_field}_sort #{sort_direction}"
            else
              "score desc"
            end
          end

          def solr_filters(getOtherTags = true)
            filters = []
            query.filters.each do |key, value|
              filters.push(format_filter("#{key}_s", value))
            end
            configuration.facets.each do |facet|
              if value = query.facet(facet.name)
                filters.push(format_filter("#{facet.name}_facet", value, getOtherTags))
              end
            end
            filters
          end

          def format_filter(field, value, tag = false)
            filter = "#{field}:\"#{value}\""
            if tag
              filter = "{!tag=#{field}}#{filter}"
            end
            filter
          end

          def connection
            Waggle::Adapters::Solr.session.connection
          end

          def solr_docs
            solr_response.fetch("docs", [])
          end

          def solr_response
            result.fetch("response", {})
          end

          def solr_facets
            result.fetch("facet_counts", {}).fetch("facet_fields", {})
          end

          def solr_facet(field)
            solr_facets.fetch("#{field}_facet", nil)
          end

          def sort_field
            @sort_field ||= query.sort_field
          end

          def sort_direction
            @sort_direction ||= query.sort_direction
          end

          def configuration
            query.configuration
          end
        end
      end
    end
  end
end
