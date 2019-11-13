class SeriesController < ApplicationController
  def index
    filter = { series_cont: params[:term] }
    @series = Book.ransack(filter).result(distinct: true).pluck(:series)

    respond_to do |format|
      format.json {
        render json: @series
      }
    end
  end
end
