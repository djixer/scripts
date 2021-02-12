#!/usr/bin/ruby

# Скрипт, в зависимости от переданного из CLI ключа:
# - сохраняет текущие показания принятых байт на интерфейсе
# - отображает суммарный текущий трафик

time = Time.now.strftime("%Y.%m.%d\t%H:%M")
current_bytes = %x(ifconfig enx0469f8ec943b | grep -m1 RX | awk '{ print $5 }').to_i

case ARGV[0]
    when "show"
        arr = []
        arr << current_bytes
        File.foreach("./summary_traffic.txt") do |line|
            arr << line.split[2].to_i
        end
        printf("%5.1f GB", arr.sum/1000000000.0)
    when "save"
        file = File.open("./summary_traffic.txt", "a")
        file.puts "#{time}\t#{current_bytes}"
        file.close
        puts "The data has been successfully saved."
    else
        'Error, command is unknown. Enter "show" or "save".'
end
