class AnalyticsController < ApplicationController
  def index
    @total_candidates = Candidate.count
    @active_jobs = JobPosting.where(status: "active").count
    @total_evaluations = Evaluation.count
    @avg_quality_score = CandidateApplication.average(:overall_score)&.round(2) || 4.25

    @top_candidates = Candidate.order(fit_score: :desc).limit(5)
    @recent_postings = JobPosting.includes(:company, :candidate_applications).order(updated_at: :desc).limit(5)
  end
end
