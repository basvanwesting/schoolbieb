class Books::FictionsController < BooksController
  before_action :set_book, only: [:show, :edit, :update, :destroy]
  def show
    authorize! :read, Book::Fiction
  end

  def edit
    authorize! :update, @book
  end

  def new
    if params[:book]
      @book = Book::Fiction.new(book_params)
    else
      @book = Book::Fiction.new
    end
    authorize! :create, @book
  end

  def update
    authorize! :update, @book
    respond_to do |format|
      if @book.update(book_params)
        format.html { redirect_to @book, notice: t('action.update.success', model: Book::Fiction.model_name.human) }
      else
        format.html { render :edit }
      end
    end
  end

  def create
    @book = Book::Fiction.new(book_params)
    authorize! :create, @book

    respond_to do |format|
      if @book.save
        format.html { redirect_to @book, notice: t('action.create.success', model: Book::Fiction.model_name.human) }
      else
        format.html { render :new }
      end
    end
  end

  def destroy
    authorize! :destroy, @book
    @book.destroy
    respond_to do |format|
      format.html { redirect_to books_url, notice: t('action.destroy.success', model: Book.model_name.human) }
    end
  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def book_params
      params.require(:book).permit(:title, :series, :part, :reading_level, :avi_level, :author_id, :author_description)
    end

end
