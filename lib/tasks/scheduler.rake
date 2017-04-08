desc "Run check_in script"
task :check_in => :environment do
  puts "Running script"
  trips = Trip.where('(depart_time > ? AND depart_time <= ?) OR (return_time > ? AND return_time <= ?)', DateTime.now + 1.day, DateTime.now + 1.day + 10.minutes, DateTime.now + 1.day, DateTime.now + 1.day + 10.minutes)
  
  trips.each { |t| t.check_in }
  
  puts "done."
end
