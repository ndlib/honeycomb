require 'new_relic/agent/method_tracer'

class MetadataInputCleaner
include ::NewRelic::Agent::MethodTracer
  attr_reader :item

  def self.call(item)
    new(item).clean!
  end

  def initialize(item)
    @item = item
  end

  def clean!
    item.metadata.each do |key, value|
      ensure_value_is_array(key, value)
    end

    item.metadata.stringify_keys!
  end

  private

  def ensure_value_is_array(key, value)
    if value.is_a?(Array)
      value.compact!
      item.metadata.delete(key) if value.empty?
    else
      if value.nil?
        item.metadata.delete(key)
      else
        item.metadata[key] = value.is_a?(Hash) ? [ensure_hash(value)] : [value]
      end
    end
  end

  def ensure_hash(value)
    if value["0"]
      value["0"]
    else
      value
    end
  end

add_method_tracer :clean!, 'MetadataInputCleaner/clean!'
add_method_tracer :ensure_value_is_array, 'MetadataInputCleaner/ensure_value_is_array'
add_method_tracer :ensure_hash, 'MetadataInputCleaner/ensure_hash'
end
