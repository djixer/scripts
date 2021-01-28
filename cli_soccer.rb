#!/usr/bin/ruby
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

def game_end
  print "Время матча подошло к концу. #{@str}\r"
  interval
  puts "Итоговый счёт: #{@home[:name]} #{@score[0]}:#{@score[1]} #{@guest[:name]}. Сыграно #{@time} минут. #{@str}\r"
  return @score
end

def start_game
	if rand(1..2) == 1
		print "#{@home[:name]} начинает этот матч.#{@str}\r"
		interval
		attack(@home)
	else
		print "#{@guest[:name]} начинает этот матч.#{@str}\r"
		interval
		attack(@guest)
	end
end

def attack(command)
	if rand(1..100) <= command[:power]
		print "У #{command[:name]} получается начать атаку. Пас вперёд.#{@str}\r"
		interval
		print "#{command[:name]} наносит удар.#{@str}\r"
		interval
		@time += 1
		command == @home ? defence(@guest) : defence(@home)
	else
		print "Удар у #{command[:name]} не получается.#{@str}\r"
		interval
		print "#{command[:name]} теряет мяч.#{@str}\r"
		interval
    if @time > 90
      game_end
    end
		print "#{command == @home ? @guest[:name] : @home[:name]} начинает свою атаку.#{@str}\r"
		interval
		@time += 1
		command == @home ? attack(@guest) : attack(@home)
	end
end

def defence(command)
	print "Мяч летит в сторону ворот #{command[:name]}! #{@str}\r"
	interval
	if rand(1..100) > command[:power]
		command == @home ? @score[1] += 1 : @score[0] += 1
		goal_in(command == @home ? @guest[:name] : @home[:name])
		interval
		print "#{command == @home ? @guest[:name] : @home[:name]} забивает! Сыграно #{@time} минут. #{@str}\r"
		interval
		puts "#{@home[:name].upcase} #{@score[0]}:#{@score[1]} #{@guest[:name].upcase} #{@time} минут.#{@str}\r"
		interval
		if @time > 90
      game_end
    end
		@time += 1
		interval
		command == @home ? attack(@home) : attack(@guest)
	else
		print "#{@home[:name]} справляется с этой атакой и начинает свою. Сыграно #{@time} минут. #{@str}\r"
		interval
    if @time > 90
      game_end
    end
		@time += 1
		command == @home ? attack(@home) : attack(@guest)
	end
end

start_game
