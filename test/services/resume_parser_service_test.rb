require "test_helper"

class ResumeParserServiceTest < ActiveSupport::TestCase
  test "parses resume text and extracts career trajectory and skills" do
    resume = "Staff Software Engineer with 8 years of Ruby on Rails, PostgreSQL, and System Design experience."
    parser = ResumeParserService.new(resume)
    result = parser.parse

    assert_includes result[:detected_skills], "Rails"
    assert_equal "Staff / Principal Technical Leader", result[:trajectory]
    assert result[:estimated_comp] >= 180000
    assert result[:fit_score] >= 80.0
  end
end
