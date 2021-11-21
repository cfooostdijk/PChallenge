class PokemonsController < ApplicationController
  before_action :set_poke_client, only: %i[ index show ]
  before_action :pokemon_info, only: :show
  before_action :pokemon_info2, only: :show
  before_action :pokemon_info3, only: :show

  Poks = Struct.new(:abilities, :images, :names, :ptypes, :weights, keyword_init: true)
  Pok = Struct.new(:ability, :description, :evolution, :image, :name, :ptype, :weight, keyword_init: true)    

  #ESTE VA CON "ALL_POKES" V1 E INDEX CON @pokes.name SOLO
  # def index
  #   @pokes = Poks.new(
  #     names: all_pokes['results'].map { |p| p['name'].capitalize }.join(" ")
  #   )
  # end

  # ESTE VA CON "ALL_POKES" V2 E INDEX COMPLETO (ME TOMA UN SOLO POKE)
  def index
    @pokes = Poks.new(
      abilities: all_pokes['abilities'].map { |p| p['ability']['name'].capitalize }.join(", "),
      images: all_pokes['sprites']['other']['official-artwork']['front_default'],
      names: all_pokes['name'].capitalize,
      ptypes: all_pokes['types'].map { |p| p['type']['name'].capitalize }.join(", "),
      weights: all_pokes['weight']
    )
  end

  def show
    @poke = Pok.new(
      ability: pokemon_info['abilities'].map { |p| p['ability']['name'].capitalize }.join(", "),
      description: pokemon_info3['descriptions'][1]['description'],
      evolution: pokemon_info2['name'].capitalize,
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

  # V2
  def all_pokes
    i = 1
    id2 = (params[:id].to_i + i)
    @allpokes ||= set_poke_client.pokemon_base(id2)
  end

  # V1
  # def all_pokes
  #   @allpokes ||= set_poke_client.pokemons
  # end

  # abilities, image, name, ptype, weight
  def pokemon_info
    @pokemon1 ||= set_poke_client.pokemon_base(params[:id])
  end

  # evolutions
  def pokemon_info2
    id_chain = (params[:id].to_i + 1)
    @pokemon3 ||= set_poke_client.pokemon_base(id_chain)
  end

  # description
  def pokemon_info3
    @pokemon2 ||= set_poke_client.pokemon_base2(params[:id])
  end

end
