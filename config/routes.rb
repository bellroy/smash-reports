SmashReports3::Application.routes.draw do
  resources :reports
  root :to => "reports#index"
end
