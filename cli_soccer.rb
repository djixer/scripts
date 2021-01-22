# Для игры достаточно запустить файл.
# Гарантированно работает с версией Ruby 2.7

# Для того, чтобы корректно работало с названиями команд на кирилице:
if (Gem.win_platform?)
  Encoding.default_external = Encoding.find(Encoding.locale_charmap)
  Encoding.default_internal = __ENCODING__

  [STDIN, STDOUT].each do |io|
    io.set_encoding(Encoding.default_external, Encoding.default_internal)
  end
end

@score = [0, 0]
@home = {}
@guest = {}

print "Введите название команды, играющей дома: "
@home[:name] = gets.chomp
print "Введите силу #{@home[:name]} (от 0 до 100): "
@home[:power] = gets.chomp.to_i
print "Введите название команды, играющей в гостях: "
@guest[:name] = gets.chomp
print "Введите силу #{@guest[:name]} (от 0 до 100): "
@guest[:power] = gets.chomp.to_i


@time = 0
@str = ""
40.times { @str += " " }

def interval
	sleep 0.1
end

def self.goal_in(team)
   10.times {print "#{team.upcase} GOAL!#{@str}\r"; interval; print "#{@str}\r"; interval}
end

def start_game
	if rand(1..2) == 1
		puts "#{@home[:name]} начинает этот матч.#{@str}\r"
		interval
		home_attack
	else
		puts "#{@guest[:name]} начинает этот матч.#{@str}\r"
		interval
		guest_attack
	end
end

# Домашняя команда с мячом. Атакующее действие получается с вероятностью силы домашней команды:
def home_attack
	if rand(1..100) <= @home[:power]
		print "У #{@home[:name]} получается начать атаку. Пас вперёд.#{@str}\r"
		interval
		print "#{@home[:name]} наносит удар.#{@str}\r"
		interval
		@time += 1
		guest_defence
	else
		print "Удар у #{@home[:name]} не получается.#{@str}\r"
		interval
		print "#{@home[:name]} теряет мяч.#{@str}\r"
		interval
		if @time > 90
			print "Время матча подошло к концу.#{@str}\r"
			interval
			puts "Итоговый счёт: #{@home[:name]} #{@score[0]}:#{@score[1]} #{@guest[:name]}. Сыграно #{@time} минут.#{@str}\r"
			return @score
		end
		print "#{@guest[:name]} начинает свою атаку.#{@str}\r"
		interval
		@time += 1
		guest_attack
	end	
end

# Домашняя команда защищается. Защитное действие получается с вероятностью силы домашней команды:
def home_defence
	print "Мяч летит в сторону ворот #{@home[:name]}! #{@str}\r"
	interval
	if rand(1..100) > @home[:power]
		@score[1] += 1
		goal_in(@guest[:name])
		interval
		print "#{@guest[:name]} забивает! Сыграно #{@time} минут. #{@str}\r"
		interval
		puts "#{@home[:name].upcase} #{@score[0]}:#{@score[1]} #{@guest[:name].upcase} #{@time} минут.#{@str}\r"
		interval
		if @time > 90
			print "Время матча подошло к концу. #{@str}\r"
			interval
			puts "Итоговый счёт: #{@home[:name]} #{@score[0]}:#{@score[1]} #{@guest[:name]}. Сыграно #{@time} минут. #{@str}\r"
			return @score
		end
		@time += 1
		interval
		home_attack
	else
		print "#{@home[:name]} справляется с этой атакой и начинает свою. Сыграно #{@time} минут. #{@str}\r"
		interval
		if @time > 90
			print "Время матча подошло к концу. #{@str}\r"
			interval
			puts "Итоговый счёт: #{@home[:name]} #{@score[0]}:#{@score[1]} #{@guest[:name]}. Сыграно #{@time} минут. #{@str}\r"
			return @score
		end
		@time += 1
		home_attack
	end
end

# Гостевая команда с мячом. Атакующее действие получается с вероятностью силы гостевой команды:
def guest_attack
	if rand(1..100) <= @guest[:power]
		print "У #{@guest[:name]} получается начать атаку. Пас вперёд. #{@str}\r"
		interval
		print "#{@guest[:name]} наносит удар. #{@str}\r"
		interval
		@time += 1
		home_defence
	else
		print "Удар у #{@guest[:name]} не получается. #{@str}\r"
		interval
		print "#{@guest[:name]} теряет мяч. #{@str}\r"
		interval
		if @time > 90
			print "Время матча подошло к концу. #{@str}\r"
			interval
			print "Итоговый счёт: #{@home[:name]} #{@score[0]}:#{@score[1]} #{@guest[:name]}. Сыграно #{@time} минут. #{@str}\r"
			return @score
		end
		print "#{@home[:name]} начинает свою атаку. #{@str}\r"
		interval
		@time += 1
		home_attack
	end	
end

# Гостевая команда защищается. Защитное действие получается с вероятностью силы гостевой команды:
def guest_defence
	print "Мяч летит в сторону ворот #{@guest[:name]}! #{@str}\r"
	interval
	if rand(1..100) > @guest[:power]
		@score[0] += 1
		goal_in(@home[:name])
		interval
		print "#{@home[:name]} забивает! Сыграно #{@time} минут. #{@str}\r"
		interval
		puts "#{@home[:name].upcase} #{@score[0]}:#{@score[1]} #{@guest[:name].upcase} #{@time} минут.#{@str}\r"
		interval
		if @time > 90
			print "Время матча подошло к концу. #{@str}\r"
			interval
			puts "Итоговый счёт: #{@home[:name]} #{@score[0]}:#{@score[1]} #{@guest[:name]}. Сыграно #{@time} минут. #{@str}\r"
			return @score
		end
		@time += 1
		interval
		guest_attack
	else
		print "#{@guest[:name]} справляется с этой атакой и начинает свою. Сыграно #{@time} минут. #{@str}\r"
		interval
		if @time > 90
			print "Время матча подошло к концу. #{@str}\r"
			interval
			puts "Итоговый счёт: #{@home[:name]} #{@score[0]}:#{@score[1]} #{@guest[:name]}. Сыграно #{@time} минут. #{@str}\r"
			return @score
		end
		@time += 1
		guest_attack
	end
end

start_game
