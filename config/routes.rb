SmashReports3::Application.routes.draw do
  devise_for :users

  resources :reports
  root :to => "reports#index"
end
