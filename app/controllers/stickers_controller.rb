class StickersController < ApplicationController

  def index
    authorize! :read, Book
    scope = Book
    scope = scope.where("1 = 0") unless ransack_filter_present?
    @q = scope.ransack(params[:q])
    @books = @q.result.includes(:author).order("authors.last_name ASC, title ASC").page(params[:page]).per(60)
  end

end
