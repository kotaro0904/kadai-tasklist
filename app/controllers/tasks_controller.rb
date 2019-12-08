class TasksController < ApplicationController
  before_action :require_user_logged_in
  
  def index
    if logged_in?
      @task = current_user.tasks.build  # form_with 用
      @tasks = current_user.tasks.order(id: :desc).page(params[:page])
    end
  end

  def show
      @task = Task.find(params[:id])
  end

  def new
      @task = Task.new
  end
  
  def create
    @task = current_user.tasks.build(tasks_params)
    if @task.save
      flash[:success] = 'Taskを投稿しました。'
      redirect_to root_url
    else
      @tasks = current_user.tasks.order(id: :desc).page(params[:page])
      flash.now[:danger] = 'Taskの投稿に失敗しました。'
      render 'tasks/index'
    end
  end
  
  def edit
      @task = Task.find(params[:id])
  end
  
  def update
     @task = Task.find(params[:id])

    if @task.update(tasks_params)
      flash[:success] = 'Task は正常に更新されました'
      redirect_to @task
    else
      flash.now[:danger] = 'Task は更新されませんでした'
      render :edit
    end
  end
    
  def destroy
    @task = Task.find(params[:id])
    @task.destroy

    flash[:success] = 'Task は正常に削除されました'
    redirect_to tasks_url
  end
  
  private

  def set_task
    @task = Task.find(params[:id])
  end
    
 # Strong Parameter
  def tasks_params
    params.require(:task).permit(:content, :status)
  end
  
  def correct_user
    @task = current_user.tasks.find_by(id: params[:id])
    unless @task
      redirect_to root_url
    end
  end
end