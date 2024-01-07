class Tasks::CoverImagesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_task

    include ActionView::RecordIdentifier # include dom_id method identifier
  
    def destroy

      @task.cover_image.purge_later
      # debugger
      # redirect_to edit_task_path(@task)
      respond_to do |format|
        # format.turbo_stream { render "tasks/cover_image/remove_image", 
        #   locals: {cover_image_id: "cover_image_#{@task.id}" , flash_notice: "Cover image was successfully removed from your data!" }
        # }
 
        format.turbo_stream { render "tasks/cover_image/remove_image", 
               locals: {cover_image_id: "cover_image_task_#{@task.id}", task: @task, flash_notice: "Cover image was successfully removed from your data!" }
            }

        # format.turbo_stream { render turbo_stream: turbo_stream.remove(dom_id(@task, :cover_image)) }
        format.html {redirect_to edit_task_path(@task) }
    end
    end

    private

    def set_task
        @task = Task.find(params[:task_id]) if user_signed_in? 
        # rescue ActiveRecord::RecordNotFound
        #     redirect_to tasks_path
        #     flash[:danger] = "This Blog Post with id = #{params[:id]} doesnt exsists!"
    end
  
end