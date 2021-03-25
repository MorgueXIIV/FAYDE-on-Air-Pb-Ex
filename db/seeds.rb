# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'csv'
# require_relative 
def seed_actors
	Actor.delete_all
	csv_file_path = Rails.root.join('db/data/actors.csv')
	puts "Seeding users from #{csv_file_path}..."
	f = File.new(csv_file_path, 'r')
	csv = CSV.new(f)
	headers = csv.shift

	csv.each do |row|
		a_information = {
			name: row[1],
			id: row[0]
		}
		inv = Actor.create(a_information)
	end
	puts "Seeding users from #{csv_file_path} done."
end

seed_actors