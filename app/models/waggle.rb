module Waggle
  def self.setup
    adapter.setup
  end

  def self.adapter
    self::Adapters::Sunspot
  end

  def self.index(*args)
    adapter.index(*args)
  end

  def self.index!(*args)
    adapter.index!(*args)
  end
end
