# Скрипт ведёт обратный отсчёт 10 часов от момента загрузки ОС.
#!/usr/bin/ruby

boot_time = File.open('/var/log/syslog') {|file| file.find { |line| line =~ /#{Time.now.to_s[0..9]}/}[11..18]}.split(':').map(&:to_i)
current_time = [Time.now.hour, Time.now.min, Time.now.sec]
timer_in_sec = 36000

start_in_sec = [boot_time, [3600, 60, 1]].transpose.map {|x| x.reduce(:*)}.sum
current_in_sec = [current_time, [3600, 60, 1]].transpose.map {|x| x.reduce(:*)}.sum

final_in_sec = start_in_sec + timer_in_sec

def h_m_s(seconds)
	h = seconds / 3600
	m = (seconds - 3600*h) / 60
	s = seconds - 3600*h - 60*m
	return [h, m, s].map {|el| el.to_s.rjust(2, '0')}
end

end_of_timer = h_m_s(final_in_sec).join(':')

remain_in_sec = final_in_sec - current_in_sec
remain = h_m_s(remain_in_sec).join(':')

in_percents = (remain_in_sec.to_f/timer_in_sec.to_f)*100

puts "Время истекает в #{end_of_timer}"
puts "Осталось: #{remain}"
puts "В процентах осталось: #{sprintf('%.2f', in_percents)}%"