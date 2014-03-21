#!/usr/bin/ruby
# -*- coding: utf-8 -*-
require 'nokogiri'
require 'toml'
require 'open-uri'

require_relative 'premio'

class SorteoEngine
 
  def initialize
    @participantes = []
    cargar_config
    puts '************************************************'
    puts '*           Sorteo Picando Código              *'
    sleep(0.5)
    puts '*      Calentando motor de improbabilidad      *'
    sleep(1.0)
    puts '*        Contando índice de midiclorias        *'
    sleep(1.0)
    puts '*      Maldiciendo a Microsoft por deporte     *'
    sleep(1.0)
    cargar_cosas
    puts '************************************************'
  end

  def cargar_config
    @config = TOML.load_file("config.toml")
  end
  
  def cargar_cosas
    #TODO - Encapsular esto
    puts '*       Procesando datos de participantes      *'
    puts '*     Descargando comentarios de la entrada    *'
    comentarios_web = Nokogiri::HTML open(@config["sources"]["webpage"])
    puts '*            Procesando comentarios            *'

    comentarios_web.css(@config["sources"]["xpath"]).each do |n|
      participante = "Del blog: " + n.text.strip
      # TODO - Only add user if not in hash already
      @participantes.push(participante)
    end
    puts "*     Participantes en comentarios: #{@participantes.length}         *"

    # TODO - Get Tweets RTs
    cargar_tweets
  end

  def ejecutar_sorteo
    premios = @config["prizes"]

    premios.each do |premio|
      sortear(premio)
    end
  end

  def cargar_tweets
    if @config["sources"]["tweet"] != 0
      # TODO: Si el sorteo es por RT, contar RT's de un tweet por ID
    else
      count = 0
      # Si junto los tweets de forma manual (mentions)
      File.open("tweets", "r") do |tweet|
        while (line = tweet.gets)
          count += 1
          @participantes.push "De Twitter: " + line.match(/twitter.com\/([a-zA-Z0-9_]{1,15})/)[1]
        end
      end
      puts "*     Participantes en Twitter: #{count}         *"
    end
    
  end
  
  def sortear(nombre_premio)
    premio = Premio.new(nombre_premio)
    puts "PREMIO: #{premio.nombre}"
    premio.elegir_ganador @participantes
    puts 'GANADOR: ' + premio.ganador.to_s
    sleep(1.0)
  end
  
end

sorteo = SorteoEngine.new
sorteo.ejecutar_sorteo
