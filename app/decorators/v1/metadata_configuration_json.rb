module V1
  class MetadataConfigurationJSON
    attr_reader :configuration, :collection

    def initialize(configuration, collection)
      @configuration = configuration
      @collection = collection
    end

    def as_json(_options = {})
      {
        "@context" => "http://schema.org",
        "@type" => "DECMetadataConfiguration",
        fields: build_json_hash,
        facets: configuration.facets,
        sorts: configuration.sorts,
        enableBrowse: collection.enable_browse,
        enableSearch: collection.enable_search,
        hasAboutPage: collection.about.present?,
      }
    end

    def to_json(_options = {})
      as_json(_options).to_json
    end

    private

    def build_json_hash
      {}.tap do |hash|
        configuration.fields.each do |field|
          hash[field.name] = field.as_json
        end
      end
    end
  end
end
