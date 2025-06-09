json.injections do
  json.array! @injections do |injection|
    json.partial! "injection", injection: injection
  end
end
