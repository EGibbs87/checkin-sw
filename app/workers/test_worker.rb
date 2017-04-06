class TestWorker
  include Sidekiq::Worker

  def perform
    puts "working"
  end
end
