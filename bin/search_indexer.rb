#!/usr/bin/ruby -w
require 'rubygems';
require 'sqlite3'
# require 'tk';


#reads in and parses the JSON
#TEST NEW ERROR HANDLING PLS
begin
	dbname="searchLogDBrb.db"
	db=SQLite3::Database.open dbname
	starttime=Time.now()
	verbose=true
	db.execute """CREATE TABLE IF NOT EXISTS searches
	(address TEXT, time TEXT, query TEXT, actor TEXT, variables TEXT)""";

	#inistialise counter
	numberOfdbEntriesMade=0;
	logname="production.log"
	backuplognames=["prodlogsearches.txt", "../log/development.log", "../log/production.log"]
	if not File.exist? (logname) then
		backuplognames.each do | backuplogname |
			if File.exist?(backuplogname) then
				logname=backuplogname
			else
				puts "No log file to read, move file to same folder, change file to parse to #{logname} or #{backuplogname} and run again."
			end
		end
	end
	if File.exist? (logname) then
		puts "Parsing #{logname} for database #{dbname}"

		logfile= File.read(logname)
		logfile= logfile.split("\n")
		if verbose then
			puts "printing _ for line that wasn't readable as a search, O for a search that was added to the database, and x for a search that was rejected due to being a duplicate."
		end

		logfile.each do | line |
			matchy = line.match(/query=([^\s&]*)(?:&actor=)?([^\s&]*)(?:&VariableSearch=([^\s&])){0,2}.*?for (\S*) at ([\d\- :]*)/i)
			# matchy.shift
			if not matchy.nil? then
				matchy=matchy.captures
				# puts matchy.join(", ")
				resultexists = db.get_first_value "SELECT * FROM searches where time=? and query=?", [ matchy[4], matchy[0] ]
				if resultexists.nil? or resultexists.next.nil? then
					db.execute "INSERT INTO searches (query,actor,variables,address,time) values (?,?,?,?,?)", matchy
					numberOfdbEntriesMade+=1;
					if verbose then
						print "O"
					end
				else
					if verbose then
						print "x"
					end
				end
			else
				if verbose then
					print "_"
				end
			end
		end
		puts "Parsing complete with #{numberOfdbEntriesMade} records added to DB"

		# db.commit
		dateformat= /\d{4}-\d{2}-\d{2}/
		firstline=logfile.shift
		firstDate=firstline.scan(dateformat)
		lastline=logfile.pop
		lastDate=lastline.scan(dateformat)
		filename="log-#{firstDate[0]}-#{lastDate[0]}.txt"
		if File.exist?(filename) then
			put "Cannot move log file to #{filename} as that file already exists."
		else
			puts "Renaming #{logname} to #{filename}."
			File.rename( logname, filename )
		end
		endtime=Time.now()
		timetaken=endtime - starttime
		puts "Database creation/updates took #{timetaken} seconds"
		puts "using 'grep /search production.log > prodlogsearches.txt' may hasten parsing."
	end
rescue SQLite3::Exception => e
    puts "there was a Database Creation error: " + e.to_s;
    #Rollback prevents partially complete data sets being inserted
    #minimising re-run errors after an exception is raised mid records
    # puts e.trace;
    db.rollback
ensure
    # close DB, success or fail
    db.close if db
end
