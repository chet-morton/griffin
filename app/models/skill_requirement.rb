class SkillRequirement < ApplicationRecord
  belongs_to :job_posting
  has_many :evaluations, dependent: :destroy

  validates :name, presence: true, uniqueness: { scope: :job_posting_id }
  validates :weight, presence: true, numericality: { greater_than: 0 }
  validates :minimum_score, presence: true, numericality: { only_integer: true, in: 1..5 }

  # Percentage weight relative to total posting skills
  def weight_percentage
    total = job_posting.total_skill_weight
    return 0.0 if total.zero?
    ((weight / total) * 100).round(1)
  end
end
