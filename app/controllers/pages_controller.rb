class PagesController < ApplicationController
  def index
    check_user_edits!(collection)
    @pages = PageQuery.new(collection.pages).ordered
    cache_key = CacheKeys::Generator.new(key_generator: CacheKeys::Custom::Pages,
                                         action: "index",
                                         collection: collection)
    fresh_when(etag: cache_key.generate)

    @list_items = ListEntryGenerator.page_entries(@pages)
  end

  def new
    check_user_edits!(collection)
    @page = PageQuery.new(collection.pages).build
  end

  def create # rubocop:disable Metrics/AbcSize
    check_user_edits!(collection)
    @page = PageQuery.new(collection.pages).build

    if SavePage.call(@page, save_params)
      flash[:html_safe] = t(".success", href: view_context.link_to("Site Setup", site_setup_form_collection_path(collection, form: :site_path))).html_safe
      redirect_to edit_page_path(@page.unique_id)
    else
      render :new
    end
  end

  def edit
    @page = PageQuery.new.public_find(params[:id])
    check_user_edits!(@page.collection)
    cache_key = CacheKeys::Generator.new(key_generator: CacheKeys::Custom::Pages,
                                         action: "edit",
                                         page: @page)
    fresh_when(etag: cache_key.generate)
  end

  def update
    @page = PageQuery.new.find(params[:id])
    check_user_edits!(@page.collection)

    if SavePage.call(@page, save_params)
      flash[:notice] = t(".success")
      redirect_to edit_page_path(@page.unique_id)
    else
      render :edit
    end
  end

  def destroy
    @page = PageQuery.new.find(params[:id])
    check_user_edits!(@page.collection)
    Destroy::Page.new.cascade!(page: @page)

    flash[:notice] = t(".success")
    redirect_to collection_pages_path(@page.collection)
  end

  protected

  def save_params
    params.require(:page).permit([
      :name,
      :content,
      :uploaded_image
    ])
  end

  def collection
    @collection ||= CollectionQuery.new.find(params[:collection_id])
  end
end
