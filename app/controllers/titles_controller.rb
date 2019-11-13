class TitlesController < ApplicationController
  def index
    filter = { title_cont: params[:term] }
    @titles = Book.ransack(filter).result(distinct: true).pluck(:title)

    respond_to do |format|
      format.json {
        render json: @titles
      }
    end
  end
end
