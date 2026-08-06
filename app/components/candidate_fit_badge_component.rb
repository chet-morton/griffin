class CandidateFitBadgeComponent < ViewComponent::Base
  attr_reader :score

  def initialize(score:)
    @score = score.to_f
  end

  def color_classes
    if score >= 90.0
      "bg-emerald-500/10 text-emerald-400 border-emerald-500/20"
    elsif score >= 75.0
      "bg-indigo-500/10 text-indigo-400 border-indigo-500/20"
    else
      "bg-amber-500/10 text-amber-400 border-amber-500/20"
    end
  end
end
