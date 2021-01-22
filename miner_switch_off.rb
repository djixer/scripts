# Скрипт раз в секунду проверяет порядковый номер последнего найденного блока
# и если это тот номер, который нам нужен, то выключает майнинг на ПК (и выключает ПК при желании).

require 'open-uri'
require 'json'

i = 0
begin
  data = URI.parse("https://*****.com/api/blocks").read
  parsed = JSON.parse(data)
  block = parsed.keys[0]
  print "#{i} - "
  puts block + " " + Time.now.to_s
  sleep 1
  i += 1
end while (block == "***-***") & (i < 864000)

puts block
exec "taskkill /IM zm.exe /F"
# sleep 5
# exec "shutdown -s -t now"
