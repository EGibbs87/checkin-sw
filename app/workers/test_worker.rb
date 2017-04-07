class TestWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'high'

  def perform
    puts "working"
  end
end
