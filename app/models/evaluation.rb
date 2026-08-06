class Evaluation < ApplicationRecord
  belongs_to :candidate_application
  belongs_to :skill_requirement
  belongs_to :evaluator, class_name: "User"

  validates :score, presence: true, numericality: { only_integer: true, in: 1..5 }
  validates :skill_requirement_id, uniqueness: { scope: [:candidate_application_id, :evaluator_id], message: "has already been evaluated by this evaluator" }

  after_save :trigger_application_score_recalculation
  after_destroy :trigger_application_score_recalculation

  private

  def trigger_application_score_recalculation
    candidate_application.recalculate_overall_score!
  end
end
