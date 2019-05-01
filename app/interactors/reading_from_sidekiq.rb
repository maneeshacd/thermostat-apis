class ReadingFromSidekiq
  include Interactor

  def call
    queued_items =
      Sidekiq::Queue.new(context.queue).map(&:item).pluck('args').flatten
    reading = queued_items.find { |item| item['id'].to_s == context.reading_id }

    if reading.present?
      context.reading = reading
    else
      context.fail!(reading: {})
    end
  end
end
