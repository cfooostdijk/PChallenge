# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'pokemons#index'

  get '/pokemon', to: 'pokemons#index'
  get '/pokemon/:id', to: 'pokemons#show'
end
