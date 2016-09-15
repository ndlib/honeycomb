class SectionsController < ApplicationController
  def new
    @section_form = SectionForm.build_from_params(self)
    check_user_edits!(@section_form.collection)
  end

  def create
    check_user_edits!(showcase.collection)
    @section = SectionQuery.new(showcase.sections).build

    if section_item_id
      @section.item = ItemQuery.new.public_find(section_item_id)
    end

    respond_to do |format|
      if SaveSection.call(@section, section_params)
        format.html { redirect_to edit_showcase_path(showcase.id), notice: t(".success") }
        format.json { render json: {} }
      else
        format.html { render :new }
        format.json { render json: @section.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @section_form = SectionForm.build_from_params(self)
    check_user_edits!(@section_form.collection)
    cache_key = CacheKeys::Generator.new(key_generator: CacheKeys::Custom::Sections,
                                         action: "edit",
                                         section: @section_form.section)
    fresh_when(etag: cache_key.generate)
  end

  def update
    @section = SectionQuery.new.find(params[:id])
    check_user_edits!(@section.showcase.collection)

    respond_to do |format|
      if SaveSection.call(@section, section_params)
        format.html { redirect_to edit_showcase_path(@section.showcase.id), notice: t(".success") }
        format.json { render json: {} }
      else
        format.html { render :edit }
        format.json { render json: @section.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @section = SectionQuery.new.find(params[:id])
    check_user_edits!(@section.showcase.collection)
    Destroy::Section.new.cascade!(section: @section)

    flash[:notice] = t(".success")
    redirect_to edit_showcase_path(@section.showcase.id)
  end

  protected

  def section_item_id
    # This is to translate from public item.unique_id to internal item.id
    # Once we convert all of this to use the v1 api, we won't need to translate
    @section_item_id ||= params[:section].delete(:item_id)
  end

  def section_params
    params.require(:section).permit(:name, :image, :item_id, :description, :order, :caption, :has_spacer)
  end

  def showcase
    @showcase ||= ShowcaseQuery.new.find(params[:showcase_id])
  end
end
