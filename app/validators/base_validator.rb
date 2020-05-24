class BaseValidator < BaseService
  private

  def initialize(params)
    self.params = params
  end

  attr_accessor :params
end
