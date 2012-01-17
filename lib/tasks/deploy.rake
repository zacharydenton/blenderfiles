task :deploy do |t|
  sh "sudo rsync -rtv --delete --exclude '.git' /home/zach/code/ruby/rails/blenderfiles /var/www/blenderfiles.org/"
  sh "sudo chown -R www-data: /var/www/blenderfiles.org"
end
