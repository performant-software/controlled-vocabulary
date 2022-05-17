ControlledVocabulary::Engine.routes.draw do
  resources :reference_codes, only: :index
  resources :reference_tables
end
