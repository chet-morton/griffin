class Company < ApplicationRecord
  has_many :job_postings, dependent: :nullify
  has_many :candidates, through: :job_postings

  validates :name, presence: true, uniqueness: true
  validates :industry, presence: true

  def active_jobs_count
    job_postings.where(status: "active").count
  end

  def total_placements_count
    job_postings.joins(:candidate_applications).where(candidate_applications: { status: "hired" }).count
  end
end
