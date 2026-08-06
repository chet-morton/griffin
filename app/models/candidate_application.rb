class CandidateApplication < ApplicationRecord
  enum :status, { active: "active", hired: "hired", rejected: "rejected", withdrawn: "withdrawn" }, default: "active"

  belongs_to :candidate
  belongs_to :job_posting
  belongs_to :current_stage, class_name: "PipelineStage"
  has_many :evaluations, dependent: :destroy

  validates :status, presence: true
  validates :candidate_id, uniqueness: { scope: :job_posting_id, message: "has already applied for this position" }

  after_update_commit :broadcast_pipeline_update

  # Recalculates weighted overall score based on skill requirement evaluations
  def recalculate_overall_score!
    evals = evaluations.includes(:skill_requirement)
    return update!(overall_score: nil) if evals.empty?

    total_weighted_score = 0.0
    total_weight = 0.0

    evals.each do |eval|
      weight = eval.skill_requirement.weight
      total_weighted_score += (eval.score * weight)
      total_weight += weight
    end

    calculated = total_weight > 0 ? (total_weighted_score / total_weight).round(2) : 0.0
    update!(overall_score: calculated)
  end

  # Skill breakdown matrix with individual scores vs minimum requirements
  def skill_matrix_breakdown
    job_posting.skill_requirements.map do |requirement|
      eval = evaluations.find_by(skill_requirement_id: requirement.id)
      score = eval&.score || 0
      meets_requirement = score >= requirement.minimum_score

      {
        requirement_id: requirement.id,
        name: requirement.name,
        weight: requirement.weight,
        minimum_score: requirement.minimum_score,
        rubric_description: requirement.rubric_description,
        score: score,
        notes: eval&.notes,
        evaluator_name: eval&.evaluator&.name,
        meets_requirement: meets_requirement
      }
    end
  end

  private

  def broadcast_pipeline_update
    return unless saved_change_to_current_stage_id? || saved_change_to_overall_score? || saved_change_to_status?

    broadcast_replace_to(
      "job_posting_#{job_posting_id}_pipeline",
      target: "candidate_application_#{id}",
      partial: "candidate_applications/application_card",
      locals: { application: self }
    ) rescue nil

    broadcast_replace_to(
      "job_posting_#{job_posting_id}_pipeline",
      target: "job_posting_#{job_posting_id}_metrics",
      partial: "pipelines/pipeline_metrics",
      locals: { job_posting: job_posting }
    ) rescue nil
  end
end
