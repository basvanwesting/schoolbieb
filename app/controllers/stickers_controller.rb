class StickersController < ApplicationController

  def index
    @q = Book.ransack(params[:q])
    @books = @q.result(distinct: true).includes(:author).page(params[:page]).per(70)
  end

end
