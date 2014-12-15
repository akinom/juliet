namespace :cmd do

desc "Run Command on remote server"
task :run => 'deploy:set_rails_env' do
  on primary(:app) do
    within current_path do
      with :rails_env => fetch(:rails_env) do
        ask(:cmd, "ruby --version")
        rails_env = fetch(:rails_env);
        puts capture ("cd #{deploy_to}/current && ( RAILS_ENV=#{rails_env}  #{fetch(:cmd)} )")
      end
    end
  end
end


desc 'Invoke a rake command on remote server'
task :rake => 'deploy:set_rails_env' do
  on primary(:app) do
    within current_path do
      with :rails_env => fetch(:rails_env) do
        ask(:args, "--tasks")
        rake fetch(:args)
      end
    end
  end
end

end



