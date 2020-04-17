module Metadata
  class Configuration
    attr_reader :data
    private :data

    def initialize(data)
      @data = data
    end

    def save_field(name, values)
      f = field(name)

      if !f
        fields
        f = new_field(values)
        @fields << f
      else
        f.update(values)
      end

      return false if !f.valid?

      data.metadata = fields.map(&:to_hash)
      if data.save
        f
      else
        false
      end
    end

    def save_facet(name, values)
      f = facet(name)

      if !f
        facets
        f = new_facet(values)
        @facets << f
      elsif values != nil
        f.update(values)
      else
        facets.delete_if { |facet| facet.name === name }
      end

      return false if !f.valid?

      data.facets = facets.map { |facet| facet.to_hash.except(:field) } # exclude "field" when saving to db
      if data.save
        f
      else
        false
      end
    end

    def fields
      @fields ||= build_fields
    end

    def field(name)
      field_map[name]
    end

    def field?(name)
      field(name).present?
    end

    def label(name)
      label_map[name]
    end

    def label?(name)
      label(name).present?
    end

    def facets
      @facets ||= build_facets
    end

    def facet(name)
      facet_map[name]
    end

    def facet?(name)
      facet(name).present?
    end

    def sorts
      @sorts ||= build_sorts
    end

    def sort(name)
      sort_map[name]
    end

    def sort?(name)
      sort(name).present?
    end

    def field_names
      field_map.keys
    end

    def field_labels
      field_map.map { |_key, value| value.label }
    end

    private

    def field_map
      @field_map ||= build_field_map
    end

    def facet_map
      @facet_map ||= build_facet_map
    end

    def label_map
      @label_map ||= build_label_map
    end

    def sort_map
      @sort_map ||= build_sort_map
    end

    def build_fields
      data.metadata.map do |field_data|
        field_data = field_data.symbolize_keys
        new_field(field_data)
      end
    end

    def build_facets
      data.facets.map do |facet_data|
        facet_data = facet_data.symbolize_keys
        facet_field = field(facet_data.fetch(:field_name))
        arguments = facet_data.merge(active: facet_field.active, field: facet_field)
        Metadata::Configuration::Facet.new(**arguments)
      end
    end

    def build_sorts
      data.sorts.map do |sort_data|
        sort_data = sort_data.symbolize_keys
        sort_field = field(sort_data.fetch(:field_name))
        arguments = sort_data.merge(active: sort_field.active, field: sort_field)
        Metadata::Configuration::Sort.new(**arguments)
      end
    end

    def build_field_map
      {}.tap do |hash|
        fields.each do |field|
          hash[field.name] = field
        end
      end.with_indifferent_access
    end

    def build_label_map
      {}.tap do |hash|
        fields.each do |field|
          hash[field.label] = field
        end
      end.with_indifferent_access
    end

    def build_facet_map
      {}.tap do |hash|
        facets.each do |facet|
          hash[facet.name.to_sym] = facet
        end
      end.with_indifferent_access
    end

    def build_sort_map
      {}.tap do |hash|
        sorts.each do |sort|
          hash[sort.name.to_sym] = sort
        end
      end.with_indifferent_access
    end

    def new_field(field_data)
      self.class::Field.new(**field_data)
    end

    def new_facet(facet_data)
      self.class::Facet.new(**facet_data)
    end
  end
end
