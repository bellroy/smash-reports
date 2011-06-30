SmashReports3::Application.routes.draw do
  devise_for :users

  resources :organizations, :path => '', :only => :index do
    resources :reports
  end
end
