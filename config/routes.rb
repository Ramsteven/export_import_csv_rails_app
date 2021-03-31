Rails.application.routes.draw do

  root to: 'home#index'
  get "employees/export_csv", to: "employees#export_csv"
  get 'employees/import' => 'employees#my_import'
  resources :employees do
    collection {post :import}
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
