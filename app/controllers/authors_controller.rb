class AuthorsController < ApplicationController
  before_action :set_author, only: [:show, :update, :destroy]

  # GET /authors
  # GET /authors.json
  def index
    @authors = Author.all
    render json: @authors
  end

  # GET /authors/1
  # GET /authors/1.json
  def show
    render json: @author
  end

  # GET /authors/new
  def new
    @author = Author.new
  end

  # GET /authors/1/edit
  def edit
  end

  # POST /authors
  # POST /authors.json
  def create
    @author = Author.new(author_params)

    if @author.save
      render json: @author, status: :created, location: @author
    else
      render json: @author.errors, status: :unprocessable_entity
    end

  end

# POST /authors/batch_create
  def batch_create
    result = Author.batch_create(request.raw_post)
    if result[:success]
      render json: {success: result[:message]}, status: :ok
    else
      render json: {failed: result[:message]}, status: :unprocessable_entity
    end

  end
  # PATCH/PUT /authors/1
  # PATCH/PUT /authors/1.json
  def update
      if @author.update(author_params)
        render json: @author, status: :ok
      else
        render json: @author.errors, status: :unprocessable_entity 
      end
  end

  # PATCH/PUT /authors/batch_update
  def batch_update
    result = Author.batch_update(request.raw_post)
    logger.error "==============================="
    logger.error "#{result.inspect}"
    if result[:success]
      render json: {success: result[:message]}, status: :ok
    else
      render json: {failed: result[:message]}, status: :unprocessable_entity
    end
  end

  # DELETE /authors/1
  # DELETE /authors/1.json
  def destroy
    @author.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_author
      @author = Author.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def author_params
      # params.require(:author).permit(:name, :phone)
      params.require(:data).require(:attributes).permit(:name, :phone)
    end
end
