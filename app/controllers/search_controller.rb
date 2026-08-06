class SearchController < ApplicationController
  def index
    query = params[:q].to_s.strip

    if query.blank?
      render json: { job_postings: [], candidates: [] }
      return
    end

    jobs = JobPosting.where("title ILIKE ? OR department ILIKE ?", "%#{query}%", "%#{query}%").limit(5)
    candidates = Candidate.where("first_name ILIKE ? OR last_name ILIKE ? OR email ILIKE ?", "%#{query}%", "%#{query}%", "%#{query}%").limit(5)

    render json: {
      job_postings: jobs.map { |j| { id: j.id, title: j.title, department: j.department, url: job_posting_pipeline_path(j) } },
      candidates: candidates.map { |c| { id: c.id, name: c.full_name, email: c.email, url: candidate_application_path(c.candidate_applications.first || 1) } }
    }
  end
end
