class JobPosting < ApplicationRecord
  enum :status, { draft: "draft", active: "active", archived: "archived" }, default: "draft"

  belongs_to :company, optional: true
  has_many :pipeline_stages, -> { order(position: :asc) }, dependent: :destroy
  has_many :skill_requirements, dependent: :destroy
  has_many :candidate_applications, dependent: :destroy
  has_many :candidates, through: :candidate_applications

  validates :title, presence: true
  validates :department, presence: true
  validates :status, presence: true

  scope :active_postings, -> { where(status: :active) }

  def formatted_salary_range
    return "Undisclosed" unless min_salary.present? && max_salary.present?
    "$#{(min_salary / 1000)}k - $#{(max_salary / 1000)}k #{currency}"
  end

  def total_skill_weight
    skill_requirements.sum(:weight)
  end

  def pipeline_summary
    pipeline_stages.includes(:candidate_applications).map do |stage|
      {
        stage_id: stage.id,
        name: stage.name,
        count: stage.candidate_applications.count,
        avg_score: stage.candidate_applications.average(:overall_score)&.round(2) || 0.0
      }
    end
  end
end
