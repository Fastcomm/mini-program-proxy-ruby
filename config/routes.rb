Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get 'delete/*proxy_path', to: 'proxy#delete'
  post 'put/*proxy_path', to: 'proxy#put'
  get '*proxy_path', to: 'proxy#get'
  post '*proxy_path', to: 'proxy#post'

end
