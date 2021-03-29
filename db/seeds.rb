# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'csv'

def seed_model(model, fname,skipID=false)
	model.delete_all
	csv_file_path = Rails.root.join("db/data/#{fname}.csv")
	puts "Seeding #{model} from #{csv_file_path}..."
	f = File.new(csv_file_path, 'r')
	csv = CSV.new(f)
	headers = csv.shift
	attributes = model.attribute_names
	if skipID then
		attributes = attributes-["id"]
	end

	csv.each do |row|
		inv = model.new()
		row.each_with_index do |attr,idx|
			inv[attributes[idx]]=attr
		end
		inv.save
	end
	puts "Seeding #{model} from #{csv_file_path} done."
end

def sql_seed(fname)
	sql_file_path = Rails.root.join("db/data/#{fname}.sql")
	statements = File.read(sql_file_path).split("\n")
	puts "read #{sql_file_path}, and now"
	# REMOVE THE TRANSACTION-RELATED STATEMENTS; THEY'RE IRRELEVANT TO THIS
	statements.pop
	statements.shift
	puts "#{statements[0]}" #reassure raker that's a realstaement fro debugging purposes
	puts "#{statements[-1]}"

	connection = ActiveRecord::Base.connection();
	puts "made connection"

	connection.execute("delete from #{fname}")
	puts "deleted records"

	ActiveRecord::Base.transaction do
		statements.each_with_index do |statement, idx|
			connection.execute(statement)
			if (idx % 100) == 0 then
				print '.'
			end
		end
	end
	puts "committed transaction"
	connection.close
	puts "closed connection "
end



# seed_model(Conversation,"conversations")
# seed_model(Actor,"actors")
# seed_model(Dialogue,"dialogues",true)
sql_seed("dialogues")
puts "Dialogues must be loaded into the database \n manually with sqlite3, my appologies \n(they're extremely numerous, it takes literally hours otherwise)"