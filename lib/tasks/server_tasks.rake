# server_tasks.rake

namespace :server do

  desc 'process emails'
  task :check_mail => :environment do
    
    options = YAML.load_file("#{RAILS_ROOT}/config/mail_fetcher.yml")[ENV["RAILS_ENV"]]
    @fetcher = Fetcher.create(options)
    @fetcher.fetch
                   
  end
  
end