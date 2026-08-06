class CandidateApplicationsController < ApplicationController
  before_action :set_application, only: [:show, :update_stage]

  # Candidate Evaluation Matrix (Split-Pane View)
  def show
    @job_posting = @application.job_posting
    @candidate = @application.candidate
    @skill_requirements = @job_posting.skill_requirements
    
    # Eager load evaluations by evaluator
    @evaluations_by_requirement = @application.evaluations
      .includes(:skill_requirement, :evaluator)
      .index_by(&:skill_requirement_id)

    @current_evaluator = User.evaluators.first || User.first

    # Fetch sibling applications for J/K keyboard navigation
    sibling_applications = @job_posting.candidate_applications.order(id: :asc).pluck(:id)
    current_index = sibling_applications.index(@application.id) || 0

    @next_application_id = sibling_applications[current_index + 1]
    @prev_application_id = current_index > 0 ? sibling_applications[current_index - 1] : nil
  end

  # Drag and drop stage move endpoint via Turbo Stream
  def update_stage
    target_stage = PipelineStage.find(params[:target_stage_id])

    if @application.update(current_stage: target_stage)
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to job_posting_pipeline_path(@application.job_posting) }
      end
    else
      render json: { error: "Failed to update stage" }, status: :unprocessable_entity
    end
  end

  private

  def set_application
    @application = CandidateApplication.includes(:job_posting, :candidate).find(params[:id])
  end
end
