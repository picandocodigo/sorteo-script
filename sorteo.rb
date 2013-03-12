#!/usr/bin/ruby
# -*- coding: utf-8 -*-
require 'nokogiri'
require 'toml'
require 'open-uri'

require_relative 'premio'

class SorteoEngine
 
  def initialize
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

    # TODO - Get Tweets RTs

    @participantes = []
    comentarios_web.css(@config["sources"]["xpath"]).each do |n|
      participante = {n.text.strip => n.css(".avatar")[0]['src']}
      # TODO - Only add user if not in hash already
      @participantes.push(participante)
    end
    puts "*     Participantes en comentarios: #{@participantes.length}         *"
  end

  def ejecutar_sorteo
    premios = @config["prizes"]

    premios.each do |premio|
      sortear(premio)
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
