class StoreReadingWorker
  include Sidekiq::Worker

  def perform(params)
    Reading.create(params)
  end
end
