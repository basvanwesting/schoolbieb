class TitlesController < ApplicationController
  def index
    @titles = [
      Book.ransack(params[:q]).result(distinct: true).pluck(:title),
      ReferenceData.enriched_titles(params[:q].permit(:title_cont).to_h.symbolize_keys)
    ].flatten.sort.uniq

    respond_to do |format|
      format.json {
        render json: @titles
      }
    end
  end
end
