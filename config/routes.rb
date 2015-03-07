# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

RedmineApp::Application.routes.draw do
  resources :issues do
    resources :issue_authors , only: [:new] do
      collection do
        get :autocomplete
      end
    end
  end
end
