module V1
  class SectionsController < APIController
    def show
      @section = SectionJSONDecorator.new(SectionQuery.new.public_find(params[:id]))
    end
  end
end
