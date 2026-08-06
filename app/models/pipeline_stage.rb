class PipelineStage < ApplicationRecord
  belongs_to :job_posting
  has_many :candidate_applications, foreign_key: :current_stage_id, dependent: :restrict_with_error

  validates :name, presence: true
  validates :position, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :stage_type, presence: true, inclusion: { in: %w[screening technical_assessment interview offer] }

  default_scope { order(position: :asc) }

  def active_applications_count
    candidate_applications.where(status: "active").count
  end

  def average_score
    candidate_applications.average(:overall_score)&.round(1) || 0.0
  end
end
