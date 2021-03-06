class TopicsController < ApplicationController
  def index
    @topic = Topic.new
    @topics = Topic.visible_to(current_user).paginate(page: params[:page], per_page: 10)
    authorize @topics 
  end

  def new
    @topic = Topic.new
    authorize @topic
  end

  def show
    @topic = Topic.find(params[:id])
    authorize @topic
    @posts = @topic.posts.includes(:user).includes(:comments).paginate(page: params[:page], per_page: 10)
  end

  def edit
    @topic = Topic.find(params[:id])
    authorize @topic
  end

  def destroy
    @topic = Topic.find(params[:id])
    name = @topic.name
    authorize @topic

    if @topic.destroy
      flash[:notice] = "\"#{name}\" was deleted."
      redirect_to topics_path
    else
      flash[:error] = "Error with deleting topic. Please try again."
      render :show
    end
  end

  def create
    @topic = Topic.new(topic_params)
    authorize @topic

    if @topic.save
      redirect_to @topic, notice: "Topic was saved successfully."
    else
      flash[:error] = "Error creating topic. Please try again."
      render :new
    end
  end
   
  def update
    @topic = Topic.find(params[:id])
    authorize @topic
    
    if @topic.update_attributes(params.require(:topic).permit(:name, :id, :description, :public))
      redirect_to @topic
    else
      flash[:error] = "Error saving topic. Please try again"
      render :edit
    end
  end

  private

  def topic_params
    params.require(:topic).permit(:name,:topic_id, :id, :description, :public)
  end
end
