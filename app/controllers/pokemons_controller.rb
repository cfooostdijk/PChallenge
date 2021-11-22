class PokemonsController < ApplicationController
  before_action :set_poke_client, only: %i[ index show ]
  before_action :pokemon_info, only: :show

  Poks = Struct.new(:abilities, :images, :names, :ptypes, :weights, keyword_init: true)
  Pok = Struct.new(:ability, :description, :evolution, :image, :name, :ptype, :weight, keyword_init: true)    

  # ESTE VA CON "ALL_POKES" V1 E INDEX CON @pokes.name SOLO
  def index
    @pokes = all_pokes['results'].map { |p| p['name'].capitalize }.join(" ")
  end
  
  def show
    # POKEMON_BASE --> BASIC INFO
    @poke = Pok.new(
      ability: pokemon_info['abilities'].map { |p| p['ability']['name'].capitalize }.join(", "),
      image: pokemon_info['sprites']['other']['official-artwork']['front_default'],
      name: pokemon_info['forms'][0]['name'].capitalize,
      ptype: pokemon_info['types'].map { |p| p['type']['name'].capitalize }.join(", "),
      weight: pokemon_info['weight']
    )
    
    # POKEMON_BASE2 --> DESCRIPTION
    if pokemon_info2.present?
      @poke1 = Pok.new(
        description: pokemon_info2['descriptions'][1]['description']
      )
    else
      @poke1 = Pok.new(
        description: 'No hay descripción para este Pokemon' )
    end

    # POKEMON_BASE3 --> EVOLUTION
    if pokemon_info3.present? && pokemon_info3['types'].map { |p| p['type']['name'].capitalize }.join(", ") == pokemon_info['types'].map { |p| p['type']['name'].capitalize }.join(", ") 
      @poke2 = Pok.new(
        evolution: pokemon_info3['name'].capitalize
      )
    else
      @poke2 = Pok.new(
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
  rescue
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
