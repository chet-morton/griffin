require "test_helper"

class CandidateMatcherServiceTest < ActiveSupport::TestCase
  test "ranks candidates by vector distance and skill similarity" do
    job = JobPosting.create!(title: "Rails Engineer", department: "Engineering", description: "Hotwire, PostgreSQL, Ruby on Rails")
    SkillRequirement.create!(job_posting: job, name: "Ruby on Rails", weight: 2.0)

    Candidate.create!(first_name: "Alice", last_name: "Smith", email: "alice@example.com", resume_text: "Expert in Ruby on Rails, PostgreSQL, and Hotwire")
    Candidate.create!(first_name: "Bob", last_name: "Jones", email: "bob@example.com", resume_text: "Graphic designer with Photoshop and Figma experience")

    matcher = CandidateMatcherService.new(job)
    results = matcher.call

    assert_not_empty results
    first_match = results.first
    assert_equal "Alice", first_match[:candidate].first_name
    assert first_match[:match_percentage] > 0
  end
end
