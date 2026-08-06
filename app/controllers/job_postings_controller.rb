class JobPostingsController < ApplicationController
  before_action :set_job_posting, only: [:show, :edit, :update, :destroy]

  def index
    @job_postings = JobPosting.includes(:pipeline_stages, :skill_requirements, :candidate_applications).order(updated_at: :desc)
  end

  def show
    redirect_to job_posting_pipeline_path(@job_posting)
  end

  def new
    @job_posting = JobPosting.new
  end

  def create
    @job_posting = JobPosting.new(job_posting_params)

    if @job_posting.save
      # Seed default pipeline stages
      default_stages.each_with_index do |(name, stage_type), idx|
        @job_posting.pipeline_stages.create!(name: name, stage_type: stage_type, position: idx)
      end
      redirect_to job_posting_pipeline_path(@job_posting), notice: "Job posting created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @job_posting.update(job_posting_params)
      redirect_to job_posting_pipeline_path(@job_posting), notice: "Job posting updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_job_posting
    @job_posting = JobPosting.find(params[:id])
  end

  def job_posting_params
    params.require(:job_posting).permit(:title, :department, :description, :location, :status)
  end

  def default_stages
    [
      ["Screening", "screening"],
      ["Technical Assessment", "technical_assessment"],
      ["Interview", "interview"],
      ["Offer", "offer"]
    ]
  end
end
