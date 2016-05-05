RailsApiAuth.tap do |raa|
  raa.user_model_relation = :account # this will set up the belongs_to relation from the Login model to the Account model automatically (of course if your application uses a User model this would be :user)

  # Once sifu return a token, you will use that in all calls to his greatness

  raa.edx_client_id      = 'cab1f254be91128c28a0'
  raa.edx_client_secret  = 'b2113554b80620a20743b8e30514f8e23cbb66b8'
  raa.edx_domain         = '0.0.0.0:8000' # actually get from environment variable
  raa.edx_redirect_uri   = 'http://0.0.0.0:8000' #get from environment variable
  raa.force_ssl          = false # actually get from environment variable

end
