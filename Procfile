web: bundle exec thin start -p $PORT -e $RAILS_ENV
worker: bundle exec sidekiq -e production -C config/sidekiq.yml