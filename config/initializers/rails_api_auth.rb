RailsApiAuth.tap do |raa|
  raa.user_model_relation = :account # this will set up the belongs_to relation from the Login model to the Account model automatically (of course if your application uses a User model this would be :user)

  # Once sifu return a token, you will use that in all calls to his greatness

  raa.edx_client_id      = ENV['EDX_OAUTH2_CLIENT_ID']
  raa.edx_client_secret  = ENV['EDX_OAUTH2_CLIENT_SECRET']
  raa.edx_domain         = ENV['EDX_HOSTNAME']
  raa.edx_redirect_uri   = ENV['EDX_OAUTH2_CLIENT_REDIRECT_URI']
  raa.force_ssl          = true if ENV['EDX_OAUTH2_FORCE_SSL'].eql? 'true' else false
end
