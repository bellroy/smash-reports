SmashReports3::Application.routes.draw do
  devise_for :users, :skip => [:sessions] do
    get "/login" => "devise/sessions#new", :as => :new_user_session
    post "/login" => "devise/sessions#create", :as => :user_session
    get "/logout" => "devise/sessions#destroy", :as => :destroy_user_session
  end

  resources :organizations, :path => '', :only => :index do
    resources :reports do
      put 'revert', :on => :member
    end
  end

  root :to => "organizations#index"
end
