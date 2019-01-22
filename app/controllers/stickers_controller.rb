class StickersController < ApplicationController

  def index
    @q = Book.ransack(params[:q])
    @books = @q.result.includes(:author).order("authors.last_name ASC, title ASC").page(params[:page]).per(70)
  end

end
