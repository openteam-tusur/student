require 'openteam/capistrano/deploy'

append :linked_dirs, 'tmp/rack-cache'

namespace :sitemap do
  desc 'Create symlink from shared sitemaps to public'
  task :symlink do
    on roles(:app) do
      execute "ln -nfs #{shared_path}/sitemaps/sitemap.xml #{current_path}/public/sitemap.xml"
      execute "ln -nfs #{shared_path}/sitemaps/sitemap.xml.gz #{current_path}/public/sitemap.xml.gz"
    end
  end

  #after 'deploy', 'sitemap:symlink'
end

namespace :cache do
  desc 'Clear cache'
  task :clear do
    on roles(:app) do
      within current_path do
        execute :bundle, :exec, 'rake tmp:cache:clear'
      end
    end
  end

  #after 'deploy', 'cache:clear'
end
