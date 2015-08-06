module Waggle
  def self.setup
    adapter.setup
  end

  def self.adapter
    self::Adapters::Sunspot
  end

  def self.index(*objects)
    adapter.index(*objects)
  end

  def self.index!(*objects)
    adapter.index!(*objects)
  end

  def self.remove(*objects)
    adapter.remove(*objects)
  end

  def self.remove!(*objects)
    adapter.remove!(*objects)
  end

  def self.commit
    adapter.commit
  end
end
