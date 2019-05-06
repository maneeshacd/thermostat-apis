class Error
  attr_accessor :id, :code, :message

  def initialize(params)
    @code = params[:code]
    @message = params[:message]
  end
end
