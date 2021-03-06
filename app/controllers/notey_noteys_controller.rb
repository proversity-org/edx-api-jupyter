require 'net/http'
require 'json'
require 'base64'
require 'cgi'
require 'openssl'
require 'digest/sha1'
require 'digest'

class NoteyNoteysController < ApplicationController

  include RailsApiAuth::Authentication
  #before_action :change_cookie_to_header, except: [:set_cookie]
  before_action :check_same_user, only: [:serve_user_file]
  before_action :authenticate!
  after_action :allow_iframe, only: [:serve_user_file]
  after_action :set_cookie_header, only: [:set_cookie]

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
      url = "http://#{request.host}:3335/notebooks/#{uri}"
      redirect_to url
    else
      render json: { result: false }
    end
  end
  # rubocop:enable MethodLength

  # Redirect all other authenticated requests to Jupyter.
  # This is a catch all for routes that don't match Sifu's routes.
  def authenticate_and_route_to_jupyter
    redirect_to request.original_url 
  end

  def set_cookie
   render json: { authorized: true } 
  end

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

  # This method allows an iframe to include an authentication token
  # in its request. This is strongly advised against in
  # https://tools.ietf.org/html/rfc6750#section-2.2
  # Rails Api Auth does not support this for good reason, so this is a work around.
  # Note that in future there might be a way for us to add this header quietly
  # via ajax to the iframe call.

  def allow_iframe
    #response.headers['Access-Control-Allow-Origin'] = '*'
    #response.headers['X-Frame-Options'] = 'ALLOWALL' # 'ALLOW-FROM http://0.0.0.0:8000/'
    response.headers.except! 'X-Frame-Options'
  end

  def set_cookie_header
    key = 'some very secret string'
    signature = signature = "#{Time.now.to_i}"
    #hmac = OpenSSL::HMAC.digest('sha1',key, signature).each_byte.map { |b| b.to_s(16) }.join
    response.set_cookie 'jupyter_authorization', {:value => "#{OpenSSL::HMAC.digest('sha1',key, signature).each_byte.map { |b| b.to_s(16) }.join}", :path => "/"}
    response.set_cookie 'jupyter_timestamp', {:value => signature, :path => "/"}
    response.cookies.delete(:sifu_authorization)
    #response['set-cookie']="jupyter_authorization=#{Base64.encode64(OpenSSL::HMAC.digest('sha1',key, signature))}; path=/"
    #response['set-cookie']="jupyter_timestamp=#{signature}; path=/"
    #response.cookies['jupyter_authorization'] = "#{OpenSSL::HMAC.digest('sha1',key, signature)}; path=/"
    #response.cookies['jupyter_timestamp'] = "#{signature}; path=/"
  end

  #def change_cookie_to_header
  #  auth = request.cookies['sifu_authorization']
  #  request.headers['Authorization'] = auth unless auth.blank?
  #end

  def check_same_user
    auth = request.cookies['sifu_authorization'].split(' ')[1]
    user = Login.find_by(oauth2_token: auth)
    return render json: {"Message": "No authentication cookie detected."}, status: :unauthorized if user.nil?
    render json: {}, status: :unauthorized  unless user.uid.eql? params['username']
  end

  def notey_notey_params
    params[:notey_notey]
  end

end
