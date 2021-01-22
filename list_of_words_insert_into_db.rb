#!/usr/bin/ruby

# Скрипт берёт слова из файла all_new_words.txt со списком вида:
# ruby (ˈruːbɪ) - рубин
# is - является
# alive (əˈlaɪv) - живой
# и вносит эти слова в БД приложения на синатре.

require 'sinatra'
require 'sinatra/activerecord'

set :database, "sqlite3:enwords.db"

class Word < ActiveRecord::Base
	validates :eng_word, :presence => true, :uniqueness => true
end

# Получаем двумерный массив res_arr из слов, транскрипции (если есть) и перевода
arr = []
i = 0
File.readlines('all_new_words.txt').each do |line|
    arr[i] = line.chomp.split(' - ')
    i += 1
end

res_arr = arr.map { |x| x[0].chomp(')').split(' (').push(x[1])}

# Перебираем массив и подставляем параметры для записи в базу
# wtt - word transcription translation
res_arr.each do |wtt|
	if wtt.length == 3
		add_word = Word.new(eng_word: wtt[0], transcription: wtt[1], rus_word: wtt[2])
		add_word.save
	elsif wtt.length == 2
		add_word = Word.new(eng_word: wtt[0], rus_word: wtt[1])
		add_word.save
	else
		puts add_word[0]
	end
end
