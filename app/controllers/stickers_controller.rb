class StickersController < ApplicationController

  def index
    @q = Book.ransack(params[:q])
    @books = @q.result(distinct: true)
  end

end
