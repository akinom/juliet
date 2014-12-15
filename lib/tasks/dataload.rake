require 'csv'

namespace :data do
  desc "Load data exported from Access database"
  task :load, [:publishers, :journals, :aliases] => :environment do |t, args|
    puts "Using #{Rails.env}"
    refalias = RefType.where(:type_name => "Alias").first_or_create
    publishers = {}
    journals = {}

    ActiveRecord::Base.transaction do
      puts "Loading publishers..."
      CSV.foreach(args[:publishers], encoding: "windows-1251:utf-8",
                  headers: true, converters: :numeric) do |row|
        publisher = Publisher.create(name: row['Publisher'])
        publishers[row['ID']] = publisher
        if policy? row
          Policy.create(policyable: publisher, note: row['Notes'],
                        method_of_acquisition: policy_method(row))
        end
      end

      puts "Loading journals..."
      CSV.foreach(args[:journals], encoding: "windows-1251:utf-8",
                  headers: true, converters: :numeric) do |row|
        journal = Journal.create(name: row['OfficialTitle'],
                                 publisher: publishers[row['PublisherID']])
        journals[row['ID']] = journal
        if policy? row
          Policy.create(policyable: journal, note: row['Notes'],
                        method_of_acquisition: policy_method(row))
        end
      end

      puts "Loading aliases..."
      CSV.foreach(args[:aliases], encoding: "windows-1251:utf-8",
                  headers: true, converters: :numeric) do |row|
        journal = journals[row['JournalID']]
        if journal.nil?
          puts "#{row['JournalID']}: #{row['Title']}"
          next
        end
        if row['Title'] != journal.name
          EntityRef.create(ref_type: refalias, refable: journal,
                           refvalue: row['Title'])
        end
      end
    end
  end

  desc "Load data from ASCII file (one name per line)"
  task :file, [:type, :file, :publisher] => :environment do |t, args|
    type = args[:type] || "";
    fname = args[:file];
    pubname = args[:publisher];
    publisher = nil;
    create_opts = {};
    if (type.downcase.starts_with?("journal")) then
      type = Journal;
      if (pubname.nil?) then
        raise "Must give Publisher Name";
      end
      publisher = Publisher.find_by_name(pubname);
      if (publisher.nil?) then
        raise "Unknown Publisher #{pubname}";
      end
      create_opts = {:publisher => publisher};
      puts "Loading #{type} for '#{pubname}'from #{fname} ... ";
    elsif (type.downcase.starts_with?("publisher")) then
      type = Publisher;
      puts "Loading #{type} from file '#{fname}' ... ";
    else
      raise "type must be Journal or Publisher";
    end

    File.open(fname, "r").readlines().each do |l|
      create_opts[:name] = l.strip;
      if (not create_opts[:name].empty?) then
        obj = type.send(:find_or_create_by, create_opts);
        if (obj.persisted?) then
          puts "INFO:  #{type}\t'#{obj.name}'";
        else
          puts "ERROR: #{type}\t'#{obj.name}'";
        end
      end
    end
  end
end

def policy?(row)
  unless policy_method(row) || row['Notes']
    return false
  else
    return true
  end
end

def policy_method(row)
  if row['HarvestFromSite'] == 'TRUE'
    return "HARVEST"
  elsif row['IndividualHarvest'] == 'TRUE'
    return "INDIVIDUAL_DOWNLOAD"
  elsif row['AcceptFinalFromAuthor'] == 'TRUE'
    return "RECRUIT_FROM_AUTHOR_FPV"
  elsif row['SWORDdeposit'] == 'TRUE'
    return "SWORD"
  end
end
