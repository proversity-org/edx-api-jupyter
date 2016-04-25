RailsApiAuth.tap do |raa|
  raa.user_model_relation = :account # this will set up the belongs_to relation from the Login model to the Account model automatically (of course if your application uses a User model this would be :user)

  #$ curl -X POST -d "client_id=YOUR_CLIENT_ID&client_secret=YOUR_CLIENT_SECRET&grant_type=password&username=YOUR_USERNAME&password=YOUR_PASSWORD" http://localhost:8000/oauth2/access_token/

  #curl -X POST -d "client_id=02513e0216be89d4be3e&client_secret=86598c27fb6b1cc90af7b1fa1ab68b27bc45b1d6&code=c6c25cb0dbfad79d8903b7b664da07cf7ebe3722&grant_type=authorization_code" http://0.0.0.0:8000/oauth2/grant

  raa.edx_client_id       = '02513e0216be89d4be3e'
  raa.edx_client_secret   = '86598c27fb6b1cc90af7b1fa1ab68b27bc45b1d6'
  raa.edx_redirect_uri = ''

end
