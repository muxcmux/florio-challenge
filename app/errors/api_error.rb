# ApiError.new(@model.errors)
# ApiError.new("Something went terribly wrong")
# ApiError.new(["This is bad", "And this too"])
# ApiError.new([{ message: 'noooo', reason: 'because' }])
# ApiError.new("Nothing found", attribute: :id, reason: :missing_param, status: 404)
class ApiError < StandardError
  attr_accessor :status

  delegate :to_json, :as_json, to: :errors

  def initialize(error, attribute: nil, context: nil, reason: nil, status: 422)
    super(error)
    @error = error
    @attribute = attribute
    @context = context
    @status = status
    @reason = reason
  end

  def errors
    case @error
    when ActiveModel::Errors
      return active_model_errors
    when Array
      return message_array_errors
    end

    error = {message: @error}
    error[:attribute] = @attribute if @attribute.present?
    error[:context] = @context if @context.present?
    error[:reason] = @reason if @reason.present?

    [error]
  end

  private

  def active_model_errors
    @error.map do |error|
      {
        attribute: error.attribute,
        message: error.message,
        reason: :validation
      }
    end
  end

  def message_array_errors
    @error.map do |error|
      error.is_a?(Hash) ? error : {message: error}
    end
  end
end
