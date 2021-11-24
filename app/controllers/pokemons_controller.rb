# frozen_string_literal: true

class PokemonsController < ApplicationController
  before_action :set_poke_client, only: %i[index show]
  before_action :pokemon_info, only: :show

  Poks = Struct.new(:abilities, :images, :names, :ptypes, :urls, :weights, keyword_init: true)
  Pok = Struct.new(:ability, :description, :evolution, :id, :image, :name, :ptype, :weight, keyword_init: true)

  def index
    pokes = []
    all_pokes.each do |k, value|
      if k == 'results'
        value.each do |key, val|
          response = Faraday.get(key["url"])
          response = Oj.load(response.body)
          pokes.push(response)
        end
      end
    end

    @pokes = []
    pokes.each do |poke|
      @poke = Poks.new(
        abilities: poke['abilities']&.map { |p| p['ability']['name'].capitalize }.join(", "),
        images: poke['sprites']['other']['official-artwork']['front_default'],
        names: poke['forms'][0]['name'].capitalize,
        ptypes:  poke['types'].map { |p| p['type']['name'].capitalize }.join(", "),
        urls: poke['id'],
        weights:  poke['weight']
      ) 
      @pokes << @poke
    end
  end

  def show
    # POKEMON_BASE --> BASIC INFO
    @poke = Pok.new(
      ability: pokemon_info['abilities'].map { |p| p['ability']['name'].capitalize }.join(', '),
      id: pokemon_info['id'],
      image: pokemon_info['sprites']['other']['official-artwork']['front_default'],
      name: pokemon_info['forms'][0]['name'].capitalize,
      ptype: pokemon_info['types'].map { |p| p['type']['name'].capitalize }.join(', '),
      weight: pokemon_info['weight']
    )

    # POKEMON_BASE2 --> DESCRIPTION --> LANGUAJE SET ON [1]: SPANISH
    @poke1 = if pokemon_info2.present?
               Pok.new(
                 description: pokemon_info2['descriptions'][1]['description']
               )
             else
               Pok.new(
                 description: 'No hay descripción para este Pokemon'
               )
             end

    # POKEMON_BASE3 --> EVOLUTION
    @poke2 = if pokemon_info3.present? && pokemon_info3['types'].map do |p|
                  p['type']['name'].capitalize
                end.join(', ') == pokemon_info['types'].map do |p|
                                    p['type']['name'].capitalize
                                  end.join(', ')
               Pok.new(
                 evolution: pokemon_info3['name'].capitalize
               )
             else
               Pok.new(
                 evolution: 'Este Pokemon no tiene evolución'
               )
             end
  end

  private

  def set_poke_client
    @poke_client ||= PokeApi::V2::Client.new
  end

  # V1
  def all_pokes
    @allpokes ||= set_poke_client.pokemons
  end

  # POKEMON_BASE --> BASIC INFO
  def pokemon_info
    @pokemon1 ||= set_poke_client.pokemon_base(params[:id])
  rescue StandardError
    render json: { mensaje: 'Este Pokemon no existe' }
  end

  # POKEMON_BASE2 --> DESCRIPTION
  def pokemon_info2
    @pokemon2 ||= set_poke_client.pokemon_base2(params[:id])
  end

  # POKEMON_BASE3 --> EVOLUTION
  def pokemon_info3
    id_chain = (params[:id].to_i + 1)
    @pokemon3 ||= set_poke_client.pokemon_base3(id_chain)
  end
end
