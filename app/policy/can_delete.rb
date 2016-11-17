# Some debate on if this should be 1 or 3 classes. If we start adding things here, break it apart (or talk about it)
class CanDelete
  def self.page?(page)
    !SiteObjectsQuery.new.exists?(collection_object: page)
  end

  def self.item?(item)
    !item.showcases.any? && !item.pages.any? && !item.children.any?
  end

  def self.showcase?(showcase)
    !SiteObjectsQuery.new.exists?(collection_object: showcase)
  end
end
