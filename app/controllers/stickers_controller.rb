class StickersController < ApplicationController

  def index
    @q = Book.ransack(params[:q])
    if @q.conditions.present?
      @books = @q.result(distinct: true).includes(:author)
    else
      @books = @q.result.where('1 = 0')
    end
  end

end
