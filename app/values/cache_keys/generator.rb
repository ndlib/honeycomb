module CacheKeys
  # Generator handles routing the cache key generation to a given
  # key generator and action for that generator
  class Generator
    attr_reader :generator, :action, :args

    def initialize(key_generator:, action: :generate, **args)
      @generator = key_generator.new
      @action = action
      @args = args
    end

    def generate
      Rails.application.config.cache_key_header + generator.send(action, **args).to_s
      # key = Rails.application.config.cache_key_header + generator.send(action, **args).to_s
      # print generator.class.name + "." + action + "='" + key + "'\n"
      # key
    end
  end
end
