class CheckInWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'high'

  def perform(*args)
    # Do something
  end
end
