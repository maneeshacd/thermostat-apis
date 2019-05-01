class StoreReadingWorker
  include Sidekiq::Worker

  def perform(params)
    return if Reading.find_by(id: params['id']).present? ||
              Reading.find_by(number: params['number']).present?

    Reading.create(params)
  end
end
