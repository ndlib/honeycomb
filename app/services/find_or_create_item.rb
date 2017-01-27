require 'new_relic/agent/method_tracer'
class FindOrCreateItem
include ::NewRelic::Agent::MethodTracer
  attr_reader :props, :item, :is_new_record, :is_changed, :is_valid
  private :is_new_record, :is_changed, :is_valid

  def self.call(props:, find_by:)
    instance = new(props: props)
    instance.using(prop_keys: find_by)
    instance
  end

  def initialize(props:)
    @item = nil
    @props = props
    @is_new_record = false
    @is_changed = false
    @is_valid = false
  end

  def new_record?
    is_new_record
  end

  # Returns true if the Item previously existed in the database and was changed.
  # This is different from just calling Item.changed? since a new item can appear
  # to have changed after assigning the attributes to the new item
  def changed?
    is_changed
  end

  def valid?
    is_valid
  end

  def save(index: true)
    if is_valid && SaveItem.call(item, {}, index: index)
      true
    else
      false
    end
  end

  # Calls find_or_create_by using the specified key/value pairs given in the props
  # when this class was instantiated. Ex:
  #   creator = FindOrCreateItem.new(props: { collection_id: 1, name: "name", description: "something" } )
  #   creator.using([:collection_id, :name])
  # will call find_or_create_by with criteria: { collection_id: 1, name: "name" }
  def using(prop_keys:)
    criteria = Hash[prop_keys.map { |key| [key, props[key]] }]
    find_or_create_by(criteria: criteria)
  end

  def find_or_create_by(criteria:)
    @item = Item.find_or_initialize_by(criteria)
    @is_new_record = item.new_record?
    update_props
    @is_changed = !item.new_record? && item.changed?
    item
  end

  private

  def update_props
    if props[:metadata].present?
      metadata = props.delete(:metadata)
      Metadata::Setter.call(item, metadata)
    end
    item.assign_attributes(props)
    CreateUniqueId.call(item)
    @is_valid = item.valid? && item.item_metadata.valid?
  end

add_method_tracer :using, 'FindOrCreateItem/using'
add_method_tracer :valid, 'FindOrCreateItem/valid'
add_method_tracer :save, 'FindOrCreateItem/save'
add_method_tracer :find_or_create_by, 'FindOrCreateItem/find_or_create_by'
add_method_tracer :update_props, 'FindOrCreateItem/update_props'
end
