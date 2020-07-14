class BooksController < ApplicationController
  before_action :set_book, only: [:qr]

  def index
    authorize! :read, Book
    @q = Book.ransack(params[:q])
    scope = @q.result.includes(:author).order("authors.last_name ASC, title ASC")

    respond_to do |format|
      format.html { @books = scope.page(params[:page]).per(100) }
      format.csv { send_data scope.to_csv, filename: "books.csv" }
    end
  end

  def stickers
    authorize! :update, Book
    scope = Book
    scope = scope.where("1 = 0") unless ransack_filter_present?
    @q = scope.ransack(params[:q])
    @books = @q.result.includes(:author).order("authors.last_name ASC, title ASC").page(params[:page]).per(60)
  end

  def qr
    authorize! :read, Book
    respond_to do |format|
      format.html { redirect_to @book, notice: 'Redirected from QR Code of Book' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book
      @book = Book.find(params[:id])
    end

end
