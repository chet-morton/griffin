require "test_helper"

class CandidateFitBadgeComponentTest < ViewComponent::TestCase
  test "renders high fit badge correctly" do
    rendered = render_inline(CandidateFitBadgeComponent.new(score: 95.5))
    assert_includes rendered.to_html, "95.5% MATCH"
  end
end
