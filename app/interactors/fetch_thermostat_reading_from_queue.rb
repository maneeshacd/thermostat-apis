class FetchThermostatReadingFromQueue
  include Interactor

  def call
    queued_items =
      Sidekiq::Queue.new(context.queue).map(&:item).pluck('args').flatten
    reading = queued_items.find { |item| item['token'] == context.token }

    if reading.present?
      context.reading = reading
    else
      context.fail!(reading: {})
    end
  end
end
