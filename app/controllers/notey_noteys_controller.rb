require 'net/http'
require 'json'
class NoteyNoteysController < ApplicationController
  include RailsApiAuth::Authentication
  #before_action :authenticate!
  after_action :allow_iframe

  # Check if base file exists when creating xblock
  # GET 'v1/api/notebooks/courses/files/'
  def base_file_exists
    course =  notey_notey_params["course"]
    file   =  notey_notey_params["file"]
    uri = "/home/jupyter/#{course}_#{file}"
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
    data   =  notey_notey_params["data"]

    uri = "/home/jupyter/#{course}_#{file}"
    File.open(uri, "wb") do |f|
      f.write(data)
    end
    render json: {"result":true}
  end

  # Serve a user's notebook
  # GET 'v1/api/notebooks/users/courses/files/'
  def serve_user_file
    course   =    params["course"]
    file     =    params["file"]
    username =    params["username"]
    file_format = params[:format]
    uri = "#{username}_#{course}_#{file}.#{file_format}"
    puts "Checking if /home/jupyter/#{uri} exists"
    if File.exist?("/home/jupyter/#{uri}")
      url = "http://localhost:8889/notebooks/#{uri}"
      redirect_to url
    else
      render json: {"result":false}
    end
  end

  def user_file_exists
    puts notey_notey_params
    course =  notey_notey_params["course"]
    file   =  notey_notey_params["file"]
    username = notey_notey_params["username"]

    uri = "/home/jupyter/#{username}_#{course}_#{file}"
    if File.exist?(uri)
      render json: {"result":true}
    else
      render json: {"result":false}
    end
  end


  # Create a user's notebook
  # POST 'v1/api/notebooks/users/courses/files/'
  def user_file_create
    course   = notey_notey_params["course"]
    file     = notey_notey_params["file"]
    username = notey_notey_params["username"]

    uri = "/home/jupyter/#{username}_#{course}_#{file}"
    base_file = "/home/jupyter/#{course}_#{file}"

    if File.exist?(base_file)
      File.open(base_file, "rb") do |input|
        File.open(uri, "wb") do |output|
          while buff = input.read(4096)
            output.write(buff)
          end
        end
      end
    else
      render json: {"result":false}
    end
      render json: {"result":true}
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
