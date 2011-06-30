SmashReports3::Application.routes.draw do
  devise_for :users

  resources :organizations, :path => '' do
    resources :reports
  end
end
