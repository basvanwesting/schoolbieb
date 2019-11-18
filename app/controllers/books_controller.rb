class BooksController < ApplicationController
  before_action :set_book, only: [:qr, :set_sticker_pending, :unset_sticker_pending]

  # GET /books
  # GET /books.json
  def index
    @q = Book.ransack(params[:q])
    scope = @q.result.includes(:author).order("authors.last_name ASC, title ASC")

    respond_to do |format|
      format.html { @books = scope.page(params[:page]).per(100) }
      format.csv { send_data scope.to_csv, filename: "books.csv" }
    end
  end

  # GET /books/1/qr
  # GET /books/1/qr.json
  def qr
    respond_to do |format|
      format.html { redirect_to @book, notice: 'Redirected from QR Code of Book' }
      format.json { render :show, location: @book }
    end
  end

  def unset_sticker_pending
    @book.unset_sticker_pending!
    redirect_back fallback_location: @book
  end

  def set_sticker_pending
    @book.set_sticker_pending!
    redirect_back fallback_location: @book
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book
      @book = Book.find(params[:id])
    end

end
