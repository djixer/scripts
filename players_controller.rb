# Код одного из контроллеров RoR-приложения для турнира ставок на спортивные матчи.

class PlayersController < InheritedResources::Base

def index
  @players = Player.all
  sql = "SELECT players.nickname, forecasts.bet, games.score FROM players, forecasts, games WHERE players.id = forecasts.player_id AND forecasts.game_id = games.id"
raw_data_from_db = ActiveRecord::Base.connection.execute(sql)

# Заполним хэш пустыми массивами иначе далее будет ошибка неизвестный метод [] для нил объекта. Создаём сырой (необсчитанный) массив данных hash_data_from_db:
@hash_data_from_db = {}
raw_data_from_db.each do |hash|
  @hash_data_from_db[hash["nickname"]] = [[], []]
end

raw_data_from_db_without_score_nil = raw_data_from_db.select { |hash| !hash['score'].empty? }

raw_data_from_db_without_score_nil.each do |hash|
  @hash_data_from_db[hash["nickname"]][0].push hash["bet"]
  @hash_data_from_db[hash["nickname"]][1].push hash["score"]
end
# Рассчёт очков за один прогноз:
def game_points_and_stats(player_bet, game_score)
  bet_split = player_bet.split(':')
  bet_difference = bet_split[0].to_i - bet_split[1].to_i
  score_split = game_score.split(':')
  score_difference = score_split[0].to_i - score_split[1].to_i

  if player_bet == game_score
    return 6
  elsif bet_difference == score_difference
    return 3
  elsif bet_difference < 0 && score_difference < 0 || bet_difference > 0.to_i && score_difference > 0.to_i
    return 2
  else
    0
  end
end

# Обсчитываем сырую статистику и получаем хэш с ключом-никнеймом и значениями статистики counted_stats:
counted_stats = {}
@hash_data_from_db.each do |nickname, bets_and_scores|

  i=0
  points = 0
  guessed_the_score = 0
  guessed_the_difference = 0
  guessed_the_issue = 0

  1.upto(bets_and_scores[0].size) do

    old_points = points
    points = points + game_points_and_stats(bets_and_scores[0][i], bets_and_scores[1][i])

    diff_points = points - old_points
    case diff_points
    when 6
      guessed_the_score += 1
    when 3
      guessed_the_difference += 1
    when 2
      guessed_the_issue += 1
    end
    i += 1
  end
  counted_stats[nickname] = {:points => points, :bets => bets_and_scores[0].size, :score => guessed_the_score, :difference => guessed_the_difference, :issue => guessed_the_issue}
end

# array_sort_points = counted_stats.sort_by {|k, v| -v[:points]}
@sorted_result = counted_stats.sort_by { |nickname, hash_stat| [hash_stat[:points], hash_stat[:score], hash_stat[:difference], hash_stat[:issue], hash_stat[:bets]] }.reverse

end

  private

    def player_params
      params.require(:player).permit(:nickname)
    end

end
