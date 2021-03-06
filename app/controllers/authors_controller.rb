class AuthorsController < ApplicationController
  before_action :set_author, only: [:show, :edit, :update, :destroy]

  def index
    authorize! :read, Author
    @q = Author.ransack(params[:q])
    @authors = @q.result.order("last_name ASC, first_name ASC").page(params[:page]).per(100)
  end

  def show
    authorize! :read, @author
  end

  def new
    @author = Author.new
    authorize! :create, @author
  end

  def edit
    authorize! :update, @author
  end

  def create
    @author = Author.new(author_params)
    authorize! :create, @author

    respond_to do |format|
      if @author.save
        format.html { redirect_to @author, notice: t('action.create.success', model: Author.model_name.human) }
      else
        format.html { render :new }
      end
    end
  end

  def update
    authorize! :update, @author
    respond_to do |format|
      if @author.update(author_params)
        format.html { redirect_to @author, notice: t('action.update.success', model: Author.model_name.human) }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    authorize! :destroy, @author
    @author.destroy
    respond_to do |format|
      format.html { redirect_to authors_url, notice: t('action.destroy.success', model: Author.model_name.human) }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_author
      @author = Author.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def author_params
      params.require(:author).permit(:first_name, :middle_name, :last_name)
    end
end
