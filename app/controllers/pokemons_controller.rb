class PokemonsController < ApplicationController
  before_action :set_poke_client, only: %i[ index show ]
  before_action :pokemon_info, only: :show
  before_action :pokemon_info2, only: :show
  before_action :pokemon_info3, only: :show

  Poks = Struct.new(:abilities, :images, :names, :ptypes, :weights, keyword_init: true)
  Pok = Struct.new(:ability, :description, :evolution, :image, :name, :ptype, :weight, keyword_init: true)    

  def index
    @pokemons ||= set_poke_client.pokemon_base(params[:id])
  end

  def show
    @poke = Pok.new(
      ability: pokemon_info['abilities'].map { |p| p['ability']['name'].capitalize }.join(", "),
      description: pokemon_info2['descriptions'][1]['description'],
      evolution: pokemon_info3['name'].capitalize,
      image: pokemon_info['sprites']['other']['official-artwork']['front_default'],
      name: pokemon_info['name'].capitalize,
      ptype: pokemon_info['types'].map { |p| p['type']['name'].capitalize }.join(", "),
      weight: pokemon_info['weight']
    )
  end

  # if pokemon_info['types'][0]['type']['name'] == pokemon_info3['types'][0]['type']['name']

  private

  def set_poke_client
    @poke_client ||= PokeApi::V2::Client.new
  end

  # abilities, image, name, ptype, weight
  def pokemon_info
    @pokemon1 ||= set_poke_client.pokemon_base(params[:id])
  end

  # description
  def pokemon_info2
    @pokemon2 ||= set_poke_client.pokemon_base2(params[:id])
  end

  # evolutions
  def pokemon_info3
    id_chain = (params[:id].to_i + 1)
    @pokemon3 ||= set_poke_client.pokemon_base(id_chain)
  end

end
