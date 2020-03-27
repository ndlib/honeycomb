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

          def groups
            @groups ||= solr_groups
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
            if query.group_by
              solr_response.fetch("matches", 0)
            else
              solr_response.fetch("numFound", 0)
            end
          end

          def result
            unless @result
              @result ||= connection.paginate(
                page,
                per_page,
                "select",
                params: solr_params,
              )

              @requested_tags_results ||= connection.paginate(
                page,
                0,
                "select",
                params: solr_params(false)
              )
              concat_facets
            end

            @result
          end

          def grouped?
            query.group_by ? true : false
          end

          private

          # There are cases where the facets marked by the user are not returned with a count
          # This function adds those counts back into the final list of facets returned
          def concat_facets
            if !@requested_tags_results
              return
            end

            query_counts = @result["facet_counts"]["facet_fields"]
            requested_counts = @requested_tags_results["facet_counts"]["facet_fields"]

            requested_counts.each do |facet, tags|
              tags.each_slice(2) do |tag_with_val|
                # Since these are arrays, we'll only append the values ([tag, val]) if they're not present
                unless query_counts[facet].include? tag_with_val[0]
                  query_counts[facet] += tag_with_val
                end
              end
            end
          end

          def solr_params(get_other_tags=true)
            {
              q: query.q,
              fl: "score *",
              qf: solr_query_fields,
              pf: solr_phrase_fields,
              fq: solr_filters(get_other_tags),
              sort: solr_sort,
              facet: true,
              defType: "edismax",
              :"facet.field" => facet_fields,
              mm: 1,
            }.merge(facet_limits).merge(group)
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
              result[:"f.#{facet.name}_facet.facet.limit"] = 9999
            end
            result
          end

          def group
            result = {}
            if query.group_by
              result[:group] = true
              result[:"group.field"] = query.group_by
              result[:"group.limit"] = 99999
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

          def solr_filters(get_other_tags=true)
            filters = []
            query.filters.each do |key, value|
              filters.push(format_filter("#{key}_s", value))
            end
            configuration.facets.each do |facet|
              if value = query.facet(facet.name)
                filters.push(format_filter("#{facet.name}_facet", value, get_other_tags))
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

          def solr_groups
            groups = []
            solr_response.fetch("groups", []).each do |group|
              groups << {
                id: group.fetch("groupValue", ""),
                hits: group.
                      fetch("doclist", {}).
                      fetch("docs", []).
                      map { |solr_doc| Waggle::Adapters::Solr::Search::Hit.new(solr_doc) },
              }
            end
            groups
          end

          def solr_response
            if grouped?
              result.fetch("grouped", {}).fetch(query.group_by, {})
            else
              result.fetch("response", {})
            end
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
