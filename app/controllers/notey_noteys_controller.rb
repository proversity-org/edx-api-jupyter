require 'net/http'
require 'json'
class NoteyNoteysController < ApplicationController
  include RailsApiAuth::Authentication
  after_action :allow_iframe

  # Check if base file exists when creating xblock
  # GET 'v1/api/notebooks/courses/files/'
  def base_file_exists
    course =  notey_notey_params["course"]
    file   =  notey_notey_params["file"]
    uri = "/home/jupyter/#{course}_#{file}.ipynb"
    if File.exist?(uri)
      render json: {"result":true}
    else
      render json: {"result":false}
    end
  end

  # create it if it doesn't exist
  # check if ruby allows you to lock the file
  # POST 'v1/api/notebooks/courses/files/'
  def base_file_create
    course =  notey_notey_params["course"]
    file   =  notey_notey_params["file"]
    data   =  notey_notey_params["payload"]

    uri = "/home/jupyter/#{course}_#{file}.ipynb"
    File.open(uri, "w+") do |f|
      f.write(data)
    end
    render json: true
  end

  # file uri is of the form:
  #course_file_username.ipynb
  # expect course_unit names to be unique to prevent collisions.

  # Serve a user's notebook
  # GET 'v1/api/notebooks/users/courses/files/'
  def user_file_exists
    course =  params["course"]
    file   =  params["file"]
    username = params["username"]

    uri = "#{course}_#{file}_#{username}.ipynb"
    puts "Checking if /home/jupyter/#{uri} exists"
    if File.exist?("/home/jupyter/#{uri}")
      # url will be something we can pass into docker
      url = "http://localhost:8889/notebooks/#{uri}"
      redirect_to url
    else
      render json: {"result":false}
    end
  end

  # Create a user's notebook
  # POST 'v1/api/notebooks/users/courses/files/'
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

   def allow_iframe
     response.headers['X-Frame-Options'] = 'ALLOW-FROM http://0.0.0.0:8000/'
   end

    def notey_notey_params
      params[:notey_notey]
    end
end
