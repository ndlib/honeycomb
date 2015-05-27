class ExhibitsController < ApplicationController
  def show
    redirect_to exhibit_showcases_path(params[:id])
  end

  def edit
    @exhibit = ExhibitQuery.new.find(params[:id])
    check_user_edits!(@exhibit.collection)
    cache_key = CacheKeys::Generator.new(key_generator: CacheKeys::Custom::Exhibits,
                                         action: "edit",
                                         exhibit: @exhibit)
    fresh_when(etag: cache_key.generate)
  end

  def update
    @exhibit = ExhibitQuery.new.find(params[:id])
    check_user_edits!(@exhibit.collection)

    if SaveExhibit.call(@exhibit, save_params)
      flash[:notice] = t(".success")
      redirect_to edit_exhibit_path(@exhibit)
    else
      render :edit
    end
  end

  private

  def save_params
    params.require(:exhibit).permit([:description, :image, :short_description, :about, :copyright])
  end
end
