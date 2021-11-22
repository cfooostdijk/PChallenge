class PokemonsController < ApplicationController
  before_action :set_poke_client, only: %i[ index show ]
  before_action :pokemon_info, only: :show
  before_action :pokemon_info2, only: :show
  before_action :pokemon_info3, only: :show

  Poks = Struct.new(:abilities, :images, :names, :ptypes, :weights, keyword_init: true)
  Pok = Struct.new(:ability, :description, :evolution, :image, :name, :ptype, :weight, keyword_init: true)    
  Pok1 = Struct.new(:description, keyword_init: true)

  # ESTE VA CON "ALL_POKES" V1 E INDEX CON @pokes.name SOLO
  # def index
  #   @pokes = Poks.new(
  #     names: all_pokes['results'].map { |p| p['name'].capitalize }.join(" ")
  #   )
  # end

  # ESTE VA CON "ALL_POKES" V2 E INDEX COMPLETO (ME TOMA UN SOLO POKE)
  # def index
  #   @pokes = Poks.new(
  #     abilities: all_pokes['abilities'].map { |p| p['ability']['name'].capitalize }.join(", "),
  #     images: all_pokes['sprites']['other']['official-artwork']['front_default'],
  #     names: all_pokes['name'].capitalize,
  #     ptypes: all_pokes['types'].map { |p| p['type']['name'].capitalize }.join(", "),
  #     weights: all_pokes['weight']
  #   )
  # end
  
  ###############################################################

  # ESTE VA "ALL_POKES" CON V3
  def index
    qnt = 0
    pokemons = []

    response = set_poke_client.pokemons
    response.each do
      qnt = qnt + 1
    end

    @pokesqnt = qnt

    @pokes = Poks.new(
      names: all_pokes['results'].map { |p| p['name'].capitalize }.join(" ")
    )

  end

      # pokemons = []
      # allpokes ||= set_poke_client.pokemons
      # allpokes.each do |k, value|
      #   if k == "results"
      #     value.each do 
      #       # i = 1
      #       # id2 = (params[:id].to_i + i)
      #       response = set_poke_client.pokemon_base(params[:id])
      #       # set_poke_client.pokemon_base(key["https://pokeapi.co/api/v2/pokemon/#{params[:id]}"])
      #       pokemons.push(response)
      #     end
      #   end
      # end
  # end
  
  def show
    @poke = Pok.new(
      ability: pokemon_info['abilities'].map { |p| p['ability']['name'].capitalize }.join(", "),
      # description: pokemon_info3['descriptions'][1]['description'],
      evolution: pokemon_info2['name'].capitalize,
      image: pokemon_info['sprites']['other']['official-artwork']['front_default'],
      name: pokemon_info['forms'][0]['name'].capitalize,
      ptype: pokemon_info['types'].map { |p| p['type']['name'].capitalize }.join(", "),
      weight: pokemon_info['weight']
    )

    # if pokemon_info3.nil?
    #   @poke1 = Pok1.new(
    #     description: pokemon_info3['descriptions'][1]['description']
    #   )
    # end
  end

  # INTENTO DE CONDICIONAL PARA DETERMINAR SI TIENE MAS EVOLUCIONES O NO, BASADA EN SI SON DEL MISMO TIPO CON EL SIGUIENTE POKEMON
  # if pokemon_info['types'][0]['type']['name'] == pokemon_info3['types'][0]['type']['name']

  private

  def set_poke_client
    @poke_client ||= PokeApi::V2::Client.new
  end

  # V3
  def all_pokes
    @allpokes ||= set_poke_client.pokemons
  end

  # V2 - FALTA ARMAR UN LOOP PARA DETERMINAR EL CAMBIO DE CADA POKEMON E INCORPORARLO 
  # def all_pokes
  #   i = 1
  #   id2 = (params[:id].to_i + i)
  #   @allpokes ||= set_poke_client.pokemon_base(id2)
  # end

  # V1
  # def all_pokes
  #   @allpokes ||= set_poke_client.pokemons
  # end

  # Abilities, Image, Name, Ptype, Weight
  def pokemon_info
    @pokemon1 ||= set_poke_client.pokemon_base(params[:id])
  end

  # Evolutions
  def pokemon_info2
    id_chain = (params[:id].to_i + 1)
    @pokemon3 ||= set_poke_client.pokemon_base2(id_chain)
  end

  # Description
  def pokemon_info3
    @pokemon2 ||= set_poke_client.pokemon_base3(params[:id])
  end

end
