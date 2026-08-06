class Candidate < ApplicationRecord
  has_many :candidate_applications, dependent: :destroy
  has_many :job_postings, through: :candidate_applications
  has_many :candidate_experiences, dependent: :destroy

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }

  def full_name
    "#{first_name} #{last_name}"
  end

  def initials
    "#{first_name.first}#{last_name.first}".upcase
  end

  def tag_list
    tags.to_s.split(",").map(&:strip)
  end

  scope :nearest_to_vector, ->(target_vector, limit = 10) {
    if target_vector.present? && ActiveRecord::Base.connection.adapter_name.downcase.include?("postgresql")
      select("candidates.*, (embedding <=> '#{target_vector}') AS distance")
        .order(Arel.sql("embedding <=> '#{target_vector}' ASC"))
        .limit(limit)
    else
      none
    end
  }
end
