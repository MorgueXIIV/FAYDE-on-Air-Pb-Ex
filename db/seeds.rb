# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'csv'
# require_relative './actors.csv'
def seed_actors
  # csv_file_path = './actors.csv'
  # puts "Seeding users from #{csv_file_path}..."
  # f = File.new(csv_file_path, 'r')
  # csv = CSV.new(f)
  # headers = csv.shift

  csv=["HUB",
  	"Klaasje (Miss Oranje Disco Dancer)",
"Lena, the Cryptozoologist's wife",
"Kim Kitsuragi",
"Soona, the Programmer",
"Evrart Claire",
"Garte, the Cafeteria Manager",
"The Hanged Man",
"Jean Vicquemare",
"Judit Minot",
"Trant Heidelstam",
"Joyce Messier",
"Shadow of a Shadow"]
  
  csv.each_with_index do |row, idx|
    a_information = {
      name: row,
      id: idx
    }
    inv = Actor.create(a_information)
  end
  puts 'Seeding users from #{csv_file_path} done.'
end

seed_actors