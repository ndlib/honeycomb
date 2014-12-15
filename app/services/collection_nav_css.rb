class CollectionNavCss

  def self.call(active, section)
    raise "invalid active state, #{active}" if ![:settings, :items, :exhibits].include?(section)

    if (active.to_sym == section.to_sym)
      'active'
    else
      ''
    end
  end

end
