# -*- coding: utf-8 -*-

class Premio
  attr_accessor :nombre, :ganador, :participantes
 
  def initialize(nombre)
    @nombre = nombre
  end
  
  def elegir_ganador(participantes)
    indice = rand(participantes.length)
    @ganador = participantes[indice]
    #Un premio por persona así que:
    participantes.delete(@ganador)
  end

end