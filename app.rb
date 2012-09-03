# encoding: UTF-8

require 'sinatra'
require 'date'
require 'time'
require 'json'

get '/' do
  # @today = []
  #
  # @today << {
  #   state: '✔',
  #   name: 'Actualizar a marca do portal da mobilidade para OneStopTransport (incluindo o logótipo)',
  #   project: 'TICE Sprint #11',
  #   pomodoros: 1,
  #   interrups: 2
  # }
  # @today << {
  #   state: ' ',
  #   name: 'Suporte para aplicações móveis',
  #   project: 'TICE Sprint #11',
  #   pomodoros: 0,
  #   interrups: 0
  # }
  # @today << {
  #   state: '✕',
  #   name: 'Actualizar documentação das API\'s JavaScript',
  #   project: 'TICE Sprint #11',
  #   pomodoros: 0,
  #   interrups: 0
  # }
  #
  # @later = []
  #
  # @later << {
  #   state: '✕',
  #   name: 'Apache Wookie num subdomínio (para que não fique sob o porto 8080 e para seguranças nas framed packaged)',
  #   project: 'TICE Sprint #11',
  #   pomodoros: 0,
  #   interrups: 0
  # }
  # @later << {
  #   state: ' ',
  #   name: 'Apache Wookie no servidor de produção (em vez de estar só no de testing)',
  #   project: 'TICE Sprint #11',
  #   pomodoros: 0,
  #   interrups: 0
  # }
  # @later << {
  #   state: ' ',
  #   name: 'Actualizar o Apache Wookie para a nova release',
  #   project: 'TICE Sprint #11',
  #   pomodoros: 0,
  #   interrups: 0
  # }
  # @later << {
  #   state: '✔',
  #   name: 'Sistema de navegação',
  #   project: 'Personal',
  #   pomodoros: 0,
  #   interrups: 0
  # }

  f = File.open("data/#{ Date.today.to_s }.json", 'r')
  data = JSON.parse(f.read)

  @today = []
  data['today'].keys.each do |key|
    @today << data['today'][key]
  end

  @later = []
  data['later'].keys.each do |key|
    @later << data['later'][key]
  end

  erb :hello
end

post '/save-the-day' do
  File.open("data/#{ Date.today.to_s }.json", 'w') do |f|
    f.puts params.to_json
  end
  File.open("data/#{ Time.now.to_s }.json", 'w') do |f|
    f.puts params.to_json
  end
end
