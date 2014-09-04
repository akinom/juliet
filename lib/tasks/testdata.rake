require 'csv'

namespace :testdata do

  desc 'Create a few publishers'
  task :publishers => :environment  do 
      print "ID\tPublisher\n"
      ["Elsevier",  "Wiley", "Princeton University Press", "  Committee on Data for Science and Technology"].each do |name| 
        publisher = Publisher.where(:name => name).first_or_create
        print "Publisher.#{publisher.id}\t#{publisher.name} \n"
      end
      Sunspot.commit
  end
  
  desc "Load journals from file; assign randomly to publishers; skip a couple entries"
  task :journalsLoad, [:fileName] => :environment do |t, args|
    f = File.open(args[:fileName], "r:UTF-8")
    n = 0;
    publishers = Publisher.all;
    np = publishers.length 
    print "ID\tJournalName\tPublisher\n"
    f.readlines.each do |line|
        n = n + 1; 
        next if (n % 4 == 0) 
        name = line.chop(); 
        journal = Journal.where(:name => name).first_or_create    
        journal.publisher = publishers[n % np]
        if (journal.save) then
          print "CREATE Journal.#{journal.id}\t#{journal.name}\t#{journal.publisher.name}\n"
        else
          print "ERROR Journal.#{journal.id}\t#{journal.name}\t#{journal.publisher.name}\n"
        end
    end
    Sunspot.commit
  end
end  
