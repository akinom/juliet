require 'optparse'

namespace :sunspot do
  namespace :solr do
    desc 'delete all indexes'
    task :zap_index => [:environment] do
      Sunspot.remove_all
    end
  end
end