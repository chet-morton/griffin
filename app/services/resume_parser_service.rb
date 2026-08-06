# frozen_string_literal: true

class ResumeParserService
  attr_reader :resume_text

  def initialize(resume_text)
    @resume_text = resume_text.to_s
  end

  def parse
    {
      summary: generate_ai_summary,
      trajectory: extract_trajectory,
      estimated_comp: calculate_estimated_compensation,
      detected_skills: extract_skills,
      fit_score: calculate_base_fit_score
    }
  end

  private

  def generate_ai_summary
    skills = extract_skills.join(", ")
    "Candidate demonstrates strong proficiency in #{skills.presence || 'engineering fundamentals'}. Shows steady career progression and high technical adaptability."
  end

  def extract_trajectory
    if resume_text =~ /staff|principal|lead|architect/i
      "Staff / Principal Technical Leader"
    elsif resume_text =~ /senior|5\+ years|6\+ years|7\+ years/i
      "Senior Full-Stack Contributor"
    else
      "Ascending Mid-Level Engineer"
    end
  end

  def calculate_estimated_compensation
    base = 150000
    base += 30000 if resume_text =~ /staff|principal|lead/i
    base += 20000 if resume_text =~ /rails|postgres|system design/i
    base += 15000 if resume_text =~ /5\+ years|8\+ years/i
    base
  end

  def extract_skills
    keywords = %w[Ruby Rails PostgreSQL Hotwire React Stimulus Python AWS Docker GraphQL TypeScript System\ Design pgvector]
    keywords.select { |kw| resume_text.match?(Regexp.new(Regexp.escape(kw), Regexp::IGNORECASE)) }
  end

  def calculate_base_fit_score
    skills_count = extract_skills.size
    [70.0 + (skills_count * 4.5), 98.5].min.round(1)
  end
end
