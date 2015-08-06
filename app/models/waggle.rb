module Waggle
  def self.setup
    adapter.setup
  end

  def self.adapter
    self::Adapters::Sunspot
  end
end
