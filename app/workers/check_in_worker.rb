class CheckInWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'high'

  def perform
    # Do something
  end
end
