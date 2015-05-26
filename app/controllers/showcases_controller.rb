class ShowcasesController < ApplicationController
  def index
    check_user_edits!(exhibit.collection)
    @showcases = ShowcaseQuery.new(exhibit.showcases).admin_list
    cache_key = CacheKeys::Generator.new(key_generator: CacheKeys::Custom::Showcases,
                                         action: "index",
                                         exhibit: exhibit)
    fresh_when(etag: cache_key.generate)
  end

  def new
    check_user_edits!(exhibit.collection)
    @showcase = ShowcaseQuery.new(exhibit.showcases).build
  end

  def create
    check_user_edits!(exhibit.collection)
    @showcase = ShowcaseQuery.new(exhibit.showcases).build(save_params)

    if SaveShowcase.call(@showcase, save_params)
      flash[:notice] = t(".success")
      redirect_to showcase_path(@showcase)
    else
      render :new
    end
  end

  def show
    showcase = ShowcaseQuery.new.find(params[:id])
    check_user_edits!(showcase.collection)
    @showcase = ShowcaseDecorator.new(showcase)
    if request.xhr?
      render format: :json
    else
      respond_to do |format|
        format.html { redirect_to edit_showcase_path(showcase.id) }
        format.json
      end
    end
  end

  def edit
    @showcase = ShowcaseQuery.new.find(params[:id])
    check_user_edits!(@showcase.collection)
    cache_key = CacheKeys::Generator.new(key_generator: CacheKeys::Custom::Showcases,
                                         action: "edit",
                                         showcase: @showcase)
    fresh_when(etag: cache_key.generate)
  end

  def update
    @showcase = ShowcaseQuery.new.find(params[:id])
    check_user_edits!(@showcase.collection)

    if SaveShowcase.call(@showcase, save_params)
      flash[:notice] = t(".success")
      redirect_to showcase_path(@showcase)
    else
      render :edit
    end
  end

  def title
    @showcase = ShowcaseQuery.new.find(params[:id])
    check_user_edits!(@showcase.collection)
    cache_key = CacheKeys::Generator.new(key_generator: CacheKeys::Custom::Showcases,
                                         action: "title",
                                         showcase: @showcase)
    fresh_when(etag: cache_key.generate)
  end

  def destroy
    @showcase = ShowcaseQuery.new.find(params[:id])
    check_user_edits!(@showcase.collection)

    @showcase.destroy!

    flash[:notice] = t(".success")
    redirect_to exhibit_path(@showcase.exhibit)
  end

  def publish
    @showcase = ShowcaseQuery.new.find(params[:id])
    check_user_edits!(@showcase.collection)

    unless Publish.call(@showcase)
      fail "Error publishing #{@showcase.name}"
    end

    showcase_save_success(@showcase)
  end

  def unpublish
    @showcase = ShowcaseQuery.new.find(params[:id])
    check_user_edits!(@showcase.collection)

    unless Unpublish.call(@showcase)
      fail "Error unpublishing #{@showcase.name}"
    end

    showcase_save_success(@showcase)
  end

  protected

  def save_params
    params.require(:showcase).permit([:name_line_1, :description, :image, :order])
  end

  def showcase
    @showcase ||= ShowcaseQuery.new.find(params[:id])
  end

  def exhibit
    @exhibit ||= ExhibitQuery.new.find(params[:exhibit_id])
  end

  def showcase_save_success(showcase)
    respond_to do |format|
      format.json { render json: showcase }
      format.html do
        showcase_save_html_success(showcase)
      end
    end
  end

  def showcase_save_html_success(showcase)
    flash[:notice] = t(".success")
    if params[:action] == "create"
      redirect_to edit_showcase_path(showcase)
    else
      redirect_to edit_showcase_path(showcase)
    end
  end

  def showcase_save_failure(item)
    respond_to do |format|
      format.html do
        if params[:action] == "create"
          render action: "new"
        else
          render action: "edit"
        end
      end
      format.json { render json: item.errors, status: :unprocessable_entity }
    end
  end
end
