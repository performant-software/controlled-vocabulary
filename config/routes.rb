ControlledVocabulary::Engine.routes.draw do
  resources :reference_codes, only: :index
  resources :reference_tables do
    get :find_by_key, on: :collection
  end
end
