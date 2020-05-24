class BaseService
  def self.call(params)
    new(params).call
  end

  def call
    raise NotImplementedError
  end

  private_class_method :new

  private

  def initialize(_params)
    raise NotImplementedError
  end

  def invalid_result(errors)
    OpenStruct.new(errors: errors, success?: false)
  end

  def valid_result(response)
    OpenStruct.new(response.merge(success?: true))
  end
end
