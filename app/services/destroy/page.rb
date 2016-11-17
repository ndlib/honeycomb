module Destroy
  class Page
    # Destroy the object only
    def destroy!(page:)
      if CanDelete.page?(page)
        page.destroy!
      end
    end

    # There are no additional cascades for Pages,
    # so destroys the object only
    def cascade!(page:)
      if CanDelete.page?(page)
        ActiveRecord::Base.transaction do
          DestroyPageItemAssociations.call(page_id: page.id)
          page.destroy!
        end
      end
    end
  end
end
