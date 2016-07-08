require 'net/http'
require 'json'

class NoteyNoteysController < ApplicationController

  include RailsApiAuth::Authentication
  before_action :change_query_string_to_header, only: [:serve_user_file]
  before_action :check_same_user, only: [:serve_user_file]
  before_action :authenticate!
  after_action :allow_iframe

  # Check if base file exists when creating xblock
  # GET 'v1/api/notebooks/courses/files/'
  def base_file_exists
    course =  notey_notey_params['course']
    file   =  notey_notey_params['file']
    uri = "/notebooks/#{course}_#{file}"
    if File.exist?(uri)
      render json: { result: true }
    else
      render json: { result: false }
    end
  end

  # create it if it doesn't exist
  # check if ruby allows you to lock the file
  # POST 'v1/api/notebooks/courses/files/'
  def base_file_create
    course =  notey_notey_params['course']
    file   =  notey_notey_params['file']
    data   =  notey_notey_params['data']

    uri = "/notebooks/#{course}_#{file}"
    File.open(uri, 'wb') do |f|
      f.write(data)
    end
    render json: { result: true }
  end

  # Serve a user's notebook
  # GET 'v1/api/notebooks/users/courses/files/'
  # rubocop:disable MethodLength
  def serve_user_file
    course   =    params['course']
    file     =    params['file']
    username =    params['username']
    file_format = params[:format]
    uri = "#{username}_#{course}_#{file}.#{file_format}"
    # puts "Checking if /notebooks/#{uri} exists" -- to rails logger!
    if File.exist?("/notebooks/#{uri}")
      url = "http://#{ENV['DOCKER_IP']}:3335/notebooks/#{uri}"
      redirect_to url
    else
      render json: { result: false }
    end
  end

  # rubocop:enable MethodLength
  def user_file_exists
    course =  notey_notey_params['course']
    file   =  notey_notey_params['file']
    username = notey_notey_params['username']

    uri = "/notebooks/#{username}_#{course}_#{file}"
    if File.exist?(uri)
      render json: { result: true }
    else
      render json: { result: false }
    end
  end

  # Create a user's notebook
  # POST 'v1/api/notebooks/users/courses/files/'
  # rubocop:disable MethodLength
  def user_file_create
    course   = notey_notey_params['course']
    file     = notey_notey_params['file']
    username = notey_notey_params['username']

    uri = "/notebooks/#{username}_#{course}_#{file}"
    base_file = "/notebooks/#{course}_#{file}"

    if File.exist?(base_file)
      File.open(base_file, 'rb') do |input|
        File.open(uri, 'wb') do |output|
          while (buff = input.read(4096))
            output.write(buff)
          end
        end
      end
    else
      render json: { result: false }
    end
    render json: { result: true }
  end

  # rubocop:enable MethodLength
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

  ############################################################################
  # This method allows an iframe to include an authentication token in its   #
  # request. This is strongly advised against in                             #
  # https://tools.ietf.org/html/rfc6750#section-2.2 Rails Api Auth does not  #
  # support this for good reason, so this is a work around. In future there  #
  # might be a way for us to add this header via ajax to the iframe call.    #
  ############################################################################
  def change_query_string_to_header
    k = 'Authorization'
    auth = request.query_parameters[k]
    request.headers[k] = auth
  end

  # !deprecated
  def allow_iframe
    response.headers['X-Frame-Options'] = 'ALLOWALL' # 'ALLOW-FROM http://0.0.0.0:8000/'
  end

  def check_same_user
    auth = request.query_parameters['Authorization'].split(' ')[1]
    user = Login.find_by(oauth2_token: auth)
    render json: {}, status: :unauthorized unless user.uid.eql? params['username']
  end

  def notey_notey_params
    params[:notey_notey]
  end

end