RichardProject::Application.routes.draw do
  devise_for :users, :path => 'auth', :controllers => {
    :registrations => "registrations",
    :sessions => "sessions"
  }
  devise_scope :user do
    get 'company_info', to: "registrations#company_info", as: "company_info"
  end
  root to: "welcome#index"

  resources :users
end
