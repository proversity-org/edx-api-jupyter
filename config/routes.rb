Rails.application.routes.draw do
  resources :users, except: [:new, :edit]

  get  'v1/api/notebooks/courses/files/' => 'notey_noteys#base_file_exists'
  post 'v1/api/notebooks/courses/files/' => 'notey_noteys#base_file_create'

  get  'v1/api/notebooks/users/:username/courses/:course/files/:file' => 'notey_noteys#serve_user_file'
  get  'v1/api/notebooks/users/courses/files' => 'notey_noteys#user_file_exists'
  post 'v1/api/notebooks/users/courses/files/' => 'notey_noteys#user_file_create'

  match '*path' => 'notey_noteys#authenticate_and_route_to_jupyter', via: :all

end
