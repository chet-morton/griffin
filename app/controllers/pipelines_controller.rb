class PipelinesController < ApplicationController
  def show
    @job_posting = JobPosting.includes(:skill_requirements).find(params[:job_posting_id])
    
    # Avoid N+1 queries by eager loading candidates and evaluations
    @pipeline_stages = @job_posting.pipeline_stages.includes(
      candidate_applications: [
        :candidate,
        { evaluations: [:skill_requirement, :evaluator] }
      ]
    )

    @all_job_postings = JobPosting.all
  end
end
