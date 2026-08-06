class User < ApplicationRecord
  has_many :evaluations, foreign_key: :evaluator_id, dependent: :destroy

  validates :name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :role, presence: true, inclusion: { in: %w[admin hiring_manager evaluator recruiter] }

  scope :evaluators, -> { where(role: %w[evaluator hiring_manager]) }
end
