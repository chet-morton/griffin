class EvaluationsController < ApplicationController
  def create
    @application = CandidateApplication.find(params[:candidate_application_id])
    evaluator = User.find_by(id: params[:evaluator_id]) || User.first

    eval_params = params.require(:evaluations).permit!

    eval_params.each do |skill_req_id, data|
      score = data[:score].to_i
      notes = data[:notes]

      next if score.zero?

      evaluation = Evaluation.find_or_initialize_by(
        candidate_application: @application,
        skill_requirement_id: skill_req_id,
        evaluator: evaluator
      )

      evaluation.update!(
        score: score,
        notes: notes,
        evaluated_at: Time.current
      )
    end

    @application.recalculate_overall_score!

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to candidate_application_path(@application), notice: "Evaluations saved successfully." }
    end
  end
end
