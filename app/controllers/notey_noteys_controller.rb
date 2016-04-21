class NoteyNoteysController < ApplicationController
  before_action -> { doorkeeper_authorize! :public }, all:

  # Check if base file exists when creating xblock
  # GET 'v1/api/notebooks/courses/:course/files/:file'
  def base_file_exists
    render json: true
  end

  # create it if it doesn't exist
  # POST 'v1/api/notebooks/courses/:course/files/:file' + data
  def base_file_create
    render json: true
  end

  # file uri is of the form:
  #course_username_file.ipynb
  # expect course_unit names to be unique to prevent collisions.

  # Serve a user's notebook
  # GET 'v1/api/notebooks/users/:username/courses/:course/files/:file'
  def user_file_exists
    render json: notey_notey_params
  end

  # Create a user's notebook
  # POST 'v1/api/notebooks/users/:username/courses/:course/files/:file'
  def user_file_create
    render json: notey_notey_params
  end


  # PATCH/PUT /notey_noteys/1
  # PATCH/PUT /notey_noteys/1.json
  def update
  end

  # DELETE /notey_noteys/1
  # DELETE /notey_noteys/1.json
  def destroy
    head :no_content
  end

  private

    def notey_notey_params
      params[:notey_notey]
    end
end
