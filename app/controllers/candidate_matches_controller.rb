class CandidateMatchesController < ApplicationController
  def index
    @job_posting = JobPosting.find(params[:job_posting_id])
    @matcher = CandidateMatcherService.new(@job_posting)
    @matches = @matcher.call
  end
end
