class PrototypesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_prototype, only: [:edit, :show, :update]
  before_action :move_to_index, except: [:index, :new, :create, :destroy, :update, :show]

  def index
    @prototype = Prototype.all
  end

  def new
    @prototype = Prototype.new
  end

  def create
   @prototype = Prototype.create(prototype_params)
   if @prototype.save
        redirect_to root_path
   else
    render :new
   end
  end

  def destroy
    prototype = Prototype.find(params[:id])
    if prototype.destroy
      redirect_to root_path
    else
      render :destroy
    end
  end

  def edit
  end

  def update
    if @prototype.update(prototype_params)
      redirect_to prototype_path(@prototype.id)
    else
      render :edit
  end
end
  def show
    @comment = Comment.new
    @comments = @prototype.comments.includes(:user)
  end

  private
   def prototype_params
    params.require(:prototype).permit(:title, :catch_copy, :concept, :image).merge(user_id: current_user.id)
  end

  def set_prototype
    @prototype = Prototype.find(params[:id])
  end

  def move_to_index
    unless user_signed_in? && current_user.id == @prototype.user.id
      redirect_to action: :index
    end
  end
end