class SectionsController < ApplicationController
  def index
    ### TODO: API ONLY remove in favor of the actual api.
    @section_list = ShowcaseList.new(showcase)
    check_user_edits!(@section_list.collection)
  end

  def new
    check_user_edits!(showcase.exhibit.collection)
    @section_form = SectionForm.build_from_params(self)
  end

  def create
    check_user_edits!(showcase.exhibit.collection)
    @section = SectionQuery.new(showcase.sections).build

    respond_to do |format|
      if SaveSection.call(@section, section_params)
        format.html { redirect_to edit_showcase_path(showcase.id), notice: "Section Created" }
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
    check_user_edits!(@section.showcase.exhibit.collection)

    respond_to do |format|
      if SaveSection.call(@section, section_params)
        format.html { redirect_to edit_showcase_path(@section.showcase.id), notice: "Section updated." }
        format.json { render json: {} }
      else
        format.html { render :edit }
        format.json { render json: @section.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @section = SectionQuery.new.find(params[:id])
    check_user_edits!(@section.showcase.exhibit.collection)

    @section.destroy!

    flash[:notice] = t(".success")
    redirect_to edit_showcase_path(@section.showcase.id)
  end

  protected

  def section_params
    params.require(:section).permit(:name, :image, :item_id, :description, :order, :caption)
  end

  def showcase
    @showcase ||= ShowcaseQuery.new.find(params[:showcase_id])
  end
end
