class StatCalloutComponent < ViewComponent::Base
  attr_reader :label, :value, :change, :trend

  def initialize(label:, value:, change: nil, trend: :up)
    @label = label
    @value = value
    @change = change
    @trend = trend
  end
end
