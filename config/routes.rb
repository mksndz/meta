Rails.application.routes.draw do

  get 'admin/index'

  resources :admin, only: :index

  scope 'admin' do

    resources :repositories, :collections, :roles, :users, :subjects

    resources :items do
      collection do
        get 'for/:collection_id', to: 'items#index', as: :filtered
      end
      member do
        get 'copy'
      end
    end

    resources :collections do
      collection do
        get 'for/:repository_id', to: 'collections#index', as: :filtered
      end
    end

    resources :batches do
      collection do
        get 'for/:user_id', to: 'batches#index', as: :filtered
      end
      resources :batch_items
      get 'import/xml', to: 'batch_items#xml', as: :xml_input
      post 'import/results', to: 'batch_items#from_xml', as: :import_from_xml
    end

  end

  mount Blacklight::Engine => '/'

  concern :searchable, Blacklight::Routes::Searchable.new
  concern :exportable, Blacklight::Routes::Exportable.new

  resource :catalog, only: [:index], controller: 'catalog' do
    concerns :searchable
  end

  resources :solr_documents, only: [:show], controller: 'catalog' do
    concerns :exportable
  end

  resources :bookmarks do
    concerns :exportable

    collection do
      delete 'clear'
    end
  end

  devise_for :users

  root to: 'catalog#index'

end
