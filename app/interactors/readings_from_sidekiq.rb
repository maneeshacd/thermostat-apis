class ReadingsFromSidekiq
  include Interactor

  def call
    queued_items =
      Sidekiq::Queue.new(context.queue).map(&:item).pluck('args').flatten
    readings = queued_items.uniq { |e| e[:id] }

    if readings.present?
      context.readings = readings
    else
      context.fail!(readings: [])
    end
  end
end
