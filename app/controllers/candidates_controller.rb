class CandidatesController < ApplicationController
  before_action :set_candidate, only: [:show, :edit, :update]

  def index
    @candidates = Candidate.includes(:candidate_applications, :candidate_experiences).order(created_at: :desc)
  end

  def show
    @experiences = @candidate.candidate_experiences
    @applications = @candidate.candidate_applications.includes(:job_posting, :current_stage)
  end

  private

  def set_candidate
    @candidate = Candidate.find(params[:id])
  end
end
