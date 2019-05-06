class Statistics
  attr_accessor :id, :statistics, :thermostat

  def initialize(params)
    @statistics = params[:statistics]
    @thermostat = params[:thermostat]
  end
end
