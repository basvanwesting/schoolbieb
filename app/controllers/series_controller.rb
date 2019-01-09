class SeriesController < ApplicationController
  def index
    filter = { series_cont: params[:term] }
    @series = [
      Book.ransack(filter).result(distinct: true).pluck(:series),
      ReferenceData.series(filter)
    ].flatten.sort.uniq

    #@series = [
      #Book.ransack(params[:q]).result(distinct: true).pluck(:series),
      #ReferenceData.series(params[:q].permit(:series_cont).to_h.symbolize_keys)
    #].flatten.sort.uniq

    respond_to do |format|
      format.json {
        render json: @series
      }
    end
  end
end
