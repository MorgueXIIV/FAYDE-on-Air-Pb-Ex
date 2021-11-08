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
	db.execute """CREATE TABLE IF NOT EXISTS searches
	(address TEXT, time TEXT, query TEXT, actor TEXT, variables TEXT)""";


	#inistialise counter
	numberOfdbEntriesMade=0;
	logname="production.log"

	file= File.read(logname)
	logfile= file.split("\n")
	#using transactions means the database is written to all at once making all these entries
	#which is MUCH much faster in SQLite than making a committed transation for each of the 10,000 + entries
	# db.transaction
	#I, [2021-10-20T15:16:03.982155 #39680]  INFO -- : [df61e1c4-0d26-4f5e-9d56-12f4e61df9ba] Started GET "/search?utf8=%E2%9C%93&query=body+harden&actor=&commit=Search" for 2600:387:a:9a2::22 at 2021-10-20 15:16:03 +0000

# I, [2021-11-06T14:40:07.515014 #81518]  INFO -- : [87146c08-045e-427e-8ee7-d407f2fff6f1] Started GET "/search?query=empathy&actor=&VariableSearch=0&commit=Search" for 46.59.176.96 at 2021-11-06 14:40:07 +0000
	logfile.each do | line |
		matchy = line.match(/query=([^\s&]*)(?:&actor=)?([^\s&]*).*(?:&VariableSearch=)?(\d)?.*for (\S*) at ([\d\- :]*)/i)
		# matchy.shift
		if not matchy.nil? then
			matchy=matchy.captures
			resultexists = db.query "SELECT * FROM searches where time=? and query=?", [ matchy[4], matchy[0] ]
			if resultexists.length == 0 then
				db.execute "INSERT INTO searches (query,actor,variables,address,time) values (?,?,?,?,?)", matchy.captures
				numberOfdbEntriesMade+=1;
				print "o"
			else
				print "x"
			end
		else
			print "_"
		end
	end
		puts " complete with #{numberOfdbEntriesMade} records so far"

		# db.commit
		dateformat= /\d{4}-\d{2}-\d{2}/
		first=logfile.shift
			firstDate=first.scan(dateformat)
			last=logfile.pop
			lastdate=last.scan(dateformat)
			filename="log-#{firstdate[0]}-#{lastdate[0]}.txt"
			puts filename
			File.rename( logname, filename )
	endtime=Time.now()
	timetaken=endtime - starttime
	puts "Database creation/updates took #{timetaken} seconds"


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
