namespace :service do
  [:tomcat6, :apache].each do |name|
    namespace name do
      [:stop, :start, :restart].each do |action|

        desc "#{action.to_s.capitalize} #{name}"
        task action do
          on roles([:web]) do |host|
            execute :sudo, "/sbin/service #{name} #{action.to_s}"
          end
        end
      end
    end
  end
end
