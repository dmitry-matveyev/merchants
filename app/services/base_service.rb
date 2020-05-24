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
end
