RailsApiAuth.tap do |raa|
  raa.user_model_relation = :account # this will set up the belongs_to relation from the Login model to the Account model automatically (of course if your application uses a User model this would be :user)

  #$ curl -X POST -d "client_id=YOUR_CLIENT_ID&client_secret=YOUR_CLIENT_SECRET&grant_type=password&username=YOUR_USERNAME&password=YOUR_PASSWORD" http://localhost:8000/oauth2/access_token/

  #edxapp@precise64:~/edx-platform$ curl -X POST -d "client_id=cab1f254be91128c28a0&client_secret=b2113554b80620a20743b8e30514f8e23cbb66b8&code=8dc4f849f7367b7b62adbd5b4f31f785c3ae682d&grant_type=authorization_code" http://0.0.0.0:8000/oauth2/access_token
  #{"access_token": "8ae8b494641a7d067fe3a9edfaa4feab30aef6a5", "token_type": "Bearer", "expires_in": 31535999, "refresh_token": "b6ad873c5631c1bbb149ab8b27b57bf203e50633", "scope": ""}

#On client side get hold of an authorization grant
# make sure the client redirect is to the lms base url
#$.get("/oauth2/authorize/?client_id=cab1f254be91128c28a0&state=3835661&redirect_uri=http://0.0.0.0:8000&response_type=code")
# The above call will get the authorization code needed for the call to sifu

# below is an example of an api call that will get a token from sifu if he is happy

#$.ajax({
#    type: 'POST',
#    url: 'http://localhost:3334/token',
#    beforeSend: function(xhr, settings){
#      xhr.setRequestHeader("auth_code", "3565dbefd3983074d9d1a72b0d7a4104b7715972");
#    },
#});

# Once sifu return a token, you will use that in all calls to his greatness

# Just need to figure out how to get that authorization code

  raa.edx_client_id       = 'cab1f254be91128c28a0'
  raa.edx_client_secret   = 'b2113554b80620a20743b8e30514f8e23cbb66b8'
  raa.edx_redirect_uri = 'http://0.0.0.0:8000'

end
