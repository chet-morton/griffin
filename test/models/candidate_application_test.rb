require "test_helper"

class CandidateApplicationTest < ActiveSupport::TestCase
  test "recalculates overall score using weighted average of skill evaluations" do
    job = JobPosting.create!(title: "Senior Developer", department: "Engineering")
    req1 = SkillRequirement.create!(job_posting: job, name: "Rails", weight: 3.0, minimum_score: 3)
    req2 = SkillRequirement.create!(job_posting: job, name: "SQL", weight: 1.0, minimum_score: 3)
    stage = PipelineStage.create!(job_posting: job, name: "Screening", position: 0)

    candidate = Candidate.create!(first_name: "Jane", last_name: "Doe", email: "jane@example.com")
    app = CandidateApplication.create!(candidate: candidate, job_posting: job, current_stage: stage)
    evaluator = User.create!(name: "Test Evaluator", email: "test@example.com", role: "evaluator")

    # Score: req1 (5 * 3.0) + req2 (3 * 1.0) = 15 + 3 = 18. Total weight = 4.0. Weighted average = 18 / 4 = 4.5
    Evaluation.create!(candidate_application: app, skill_requirement: req1, evaluator: evaluator, score: 5)
    Evaluation.create!(candidate_application: app, skill_requirement: req2, evaluator: evaluator, score: 3)

    app.reload
    assert_equal 4.5, app.overall_score.to_f
  end
end
