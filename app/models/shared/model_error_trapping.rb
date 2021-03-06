module ModelErrorTrapping
  def self.included(base)
    base.extend(ClassMethods)
  end

  def raise_404
    fail ActionController::RoutingError.new("Not Found")
  end

  module ClassMethods
    def raise_404
      fail ActionController::RoutingError.new("Not Found")
    end
  end
end
