module Waggle
  module Adapters
    module Solr
      class Session
        attr_reader :config

        def initialize(config = load_configuration)
          @config = config
        end

        def connection
          @connection ||= build_connection
        end

        def index(*objects)
          connection.add(objects_as_solr(*objects))
        end

        def index!(*objects)
          index(*objects)
          commit
        end

        def commit
          connection.commit
        end

        def remove(*objects)
          connection.delete_by_id(object_solr_ids(*objects))
        end

        def remove!(*objects)
          remove(*objects)
          commit
        end

        def remove_all()
          connection.delete_by_query('*:*')
          commit
        end

        private

        def objects_as_solr(*objects)
          solr_objects(*objects).map(&:as_solr)
        end

        def object_solr_ids(*objects)
          solr_objects(*objects).map(&:id)
        end

        def solr_objects(*objects)
          objects.map { |waggle_item| Waggle::Adapters::Solr::Index::Item.new(waggle_item: waggle_item) }
        end

        def load_configuration
          YAML.load_file(File.join(Rails.root, "config", "solr.yml")).fetch(Rails.env)
        end

        def connection_url
          "http://#{config.fetch('hostname')}:#{config.fetch('port')}#{config.fetch('path')}"
        end

        def build_connection
          ::RSolr.connect(
            url: connection_url,
            read_timeout: config.fetch(:read_timeout, nil),
            open_timeout: config.fetch(:open_timeout, nil),
          )
        end
      end
    end
  end
end
