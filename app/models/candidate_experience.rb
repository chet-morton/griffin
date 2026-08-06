class CandidateExperience < ApplicationRecord
  belongs_to :candidate

  validates :company_name, presence: true
  validates :role_title, presence: true
end
