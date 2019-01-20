class BooksController < ApplicationController
  before_action :set_book, only: [:show, :edit, :update, :destroy, :qr]

  # GET /books
  # GET /books.json
  def index
    @q = Book.limit(100).ransack(params[:q])
    @books = @q.result(distinct: true)
  end

  # GET /books/1
  # GET /books/1.json
  def show
  end

  # GET /books/1/qr
  # GET /books/1/qr.json
  def qr
    respond_to do |format|
      format.html { redirect_to @book, notice: 'Redirected from QR Code of Book' }
      format.json { render :show, location: @book }
    end
  end

  # GET /books/new
  def new
    if params[:book]
      @book = Book.new(book_params)
    else
      @book = Book.new
    end
  end

  # GET /books/1/edit
  def edit
  end

  # POST /books
  # POST /books.json
  def create
    @book = Book.new(book_params)

    respond_to do |format|
      if @book.save
        format.html { redirect_to @book, notice: t('action.create.success', model: Book.model_name.human) }
        format.json { render :show, status: :created, location: @book }
      else
        format.html { render :new }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /books/1
  # PATCH/PUT /books/1.json
  def update
    respond_to do |format|
      if @book.update(book_params)
        format.html { redirect_to @book, notice: t('action.update.success', model: Book.model_name.human) }
        format.json { render :show, status: :ok, location: @book }
      else
        format.html { render :edit }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /books/1
  # DELETE /books/1.json
  def destroy
    @book.destroy
    respond_to do |format|
      format.html { redirect_to books_url, notice: t('action.destroy.success', model: Book.model_name.human) }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book
      @book = Book.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def book_params
      params.require(:book).permit(:title, :series, :part, :reading_level, :avi_level, :author_id)
    end
end
