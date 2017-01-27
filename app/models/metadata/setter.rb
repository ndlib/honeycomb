require 'new_relic/agent/method_tracer'
module Metadata
include ::NewRelic::Agent::MethodTracer
  class Setter
    attr_reader :item

    def self.call(item, metadata)
      new(item).set_metadata(metadata)
    end

    def initialize(item)
      @item = item
    end

    def set_metadata(metadata)
      metadata.each do |key, value|
        set(key, value)
      end
      MetadataInputCleaner.call(item)
    end

    private

    def set(field, value)
      #if field?(field)
        item.metadata[field.to_s] = value
      #end
    end

    def field?(field)
      configuration.field?(field.to_s)
    end

    def configuration
      @configuration ||= CollectionConfigurationQuery.new(item.collection).find
    end


add_method_tracer :set_metadata, 'Metadata::Setter/set_metadata'
add_method_tracer :set, 'Metadata::Setter/set'
add_method_tracer :field?, 'Metadata::Setter/field?'
add_method_tracer :configuration, 'Metadata::Setter/configuration'
  end
end
