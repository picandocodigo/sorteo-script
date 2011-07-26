#!/usr/bin/ruby
# -*- coding: utf-8 -*-
require 'nokogiri'
require_relative 'premio'

class SorteoEngine
 
  def initialize
    puts '************************************************'
    puts '*           Sorteo Picando Código              *'
    sleep(1.0)
    puts '*      Calentando motor de improbabilidad      *'
    sleep(1.0)
    puts '*        Contando índice de midiclorias        *'
    sleep(1.0)
    puts '*      Maldiciendo a Microsoft por deporte     *'
    sleep(1.0)
    cargar_cosas
    puts '************************************************'
  end
  
  def cargar_cosas
    #TODO - Encapsular esto
    puts '*       Procesando datos de participantes      *'
    puts '*     Descargando comentarios de la entrada    *'
    `wget http://picandocodigo.net/2011/concurso-en-picando-codigo/ -O comentarios.html`
    puts '*          Descargando tweets y dents          *'
    `wget http://picandocodigo.net/concurso-picando-codigo-tweets-y-dents/ -O tyd.html`
    
    puts '*            Procesando comentarios            *'
    f = File.open("comentarios.html")
    comentarios_web = Nokogiri::HTML(f)
    f.close

    @participantes = []
    comentarios_web.css("p.author").each do |n|
      @participantes.push n.text
    end
    puts "*     Participantes en comentarios: #{@participantes.length}         *"

    f = File.open("tyd.html")
    comentarios_td = Nokogiri::HTML(f)
    f.close

    i = 0
    comentarios_td.css("a").each do |com|
      if com.text =~ /^@/
	n = com.text
	@participantes.push n
	i+=1
      end
    end
    
    puts "*     Participantes Identi.ca y Twitter: #{i}    *"
    
  end

  def ejecutar_sorteo
    #TODO - Esto debería leer de un archivo de configuración
    premios = ["Camiseta Picando Código 1", 
               "Camiseta Picando Código 2", 
               "Vale de compra SplitReason.com",
               "Revenge of the Titans", 
               "OilRush", 
               "Cómics Roy y Bea", 
               "Cómics Nicolás Peruzzo"]
    premios.shuffle!
    premios.each do |nombre_premio|
      sortear(nombre_premio)
    end
  end
  
  def sortear(nombre_premio)
    premio = Premio.new(nombre_premio)

    puts "PREMIO: #{premio.nombre}"
    premio.elegir_ganador @participantes
    puts 'GANADOR: ' + premio.ganador
    sleep(1.0)
  end
  
end

sorteo = SorteoEngine.new
sorteo.ejecutar_sorteo
