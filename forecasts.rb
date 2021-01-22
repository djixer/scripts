# Код одного из контроллеров админки ActiveAdmin:

ActiveAdmin.register Forecast do
  config.per_page = 50
  permit_params :bet, :game_id, :player_id

index title: 'Ставки' do
  selectable_column
  column :id
  
  column 'Игрок' do |forecast|
  Player.find(forecast.player_id).nickname
  end
  
  column 'Игра' do |forecast|
    Game.find(forecast.game_id).rivals
  end
 
  column :bet
  actions
end

  form title: 'Создать ставку' do |f|
    f.inputs 'Ставка' do
      f.input :bet
      f.input :player_id, :label => 'Player', :as => :select, :collection => Player.all.map{|p| ["#{p.nickname}", p.id]}
	  # По дефолту селектед будет ближайшая следующая игра:
      f.input :game_id, :label => 'Game', :as => :select, :collection => Game.all.map{|g| ["#{g.rivals}", g.id]}, :selected => Game.all.select {|g| g.date > Time.now}.first.id
    end
    f.actions
  end
end
