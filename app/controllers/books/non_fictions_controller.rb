class Books::NonFictionsController < BooksController
  before_action :set_book, only: [:show, :edit, :update, :destroy]

  def show
  end

  def edit
  end

  def new
    if params[:book]
      @book = Book::NonFiction.new(book_params)
    else
      @book = Book::NonFiction.new
    end
  end

  def update
    respond_to do |format|
      if @book.update(book_params)
        format.html { redirect_to @book, notice: t('action.update.success', model: Book::Fiction.model_name.human) }
        format.json { render :show, status: :ok, location: @book }
      else
        format.html { render :edit }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  def create
    @book = Book::NonFiction.new(book_params)

    respond_to do |format|
      if @book.save
        format.html { redirect_to @book, notice: t('action.create.success', model: Book::Fiction.model_name.human) }
        format.json { render :show, status: :created, location: @book }
      else
        format.html { render :new }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @book.destroy
    respond_to do |format|
      format.html { redirect_to books_url, notice: t('action.destroy.success', model: Book.model_name.human) }
      format.json { head :no_content }
    end
  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def book_params
      params.require(:book).permit(:title, :series, :part, :reading_level, :avi_level, :category, tags: [])
    end
end
