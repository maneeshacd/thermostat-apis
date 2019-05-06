class ErrorSerializer
  include FastJsonapi::ObjectSerializer
  attributes :code, :message
end
