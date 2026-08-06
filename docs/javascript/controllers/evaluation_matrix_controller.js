import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "scoreBadge", "overallScoreDisplay", "weightedScoreBar", "requirementRow"]

  connect() {
    this.calculateWeightedScore()
  }

  calculateWeightedScore() {
    let totalWeightedScore = 0.0
    let totalWeight = 0.0

    this.requirementRowTargets.forEach(row => {
      const weight = parseFloat(row.dataset.weight || "1.0")
      const checkedInput = row.querySelector("input[type='radio']:checked") || row.querySelector("input[type='range']")
      
      if (checkedInput) {
        const score = parseFloat(checkedInput.value || "0")
        if (score > 0) {
          totalWeightedScore += (score * weight)
          totalWeight += weight

          // Highlight requirement row status
          const minScore = parseFloat(row.dataset.minScore || "3")
          const badge = row.querySelector("[data-status-badge]")
          if (badge) {
            if (score >= minScore) {
              badge.textContent = "Meets Rubric"
              badge.className = "px-2 py-0.5 text-xs font-semibold rounded bg-emerald-500/20 text-emerald-400 border border-emerald-500/30"
            } else {
              badge.textContent = "Below Min Score"
              badge.className = "px-2 py-0.5 text-xs font-semibold rounded bg-amber-500/20 text-amber-400 border border-amber-500/30"
            }
          }
        }
      }
    })

    const overallScore = totalWeight > 0 ? (totalWeightedScore / totalWeight).round(2) : 0.0

    if (this.hasOverallScoreDisplayTarget) {
      this.overallScoreDisplayTarget.textContent = overallScore.toFixed(2)
    }

    if (this.hasWeightedScoreBarTarget) {
      const percentage = (overallScore / 5.0) * 100
      this.weightedScoreBarTarget.style.width = `${percentage}%`
    }
  }

  scoreChanged(event) {
    this.calculateWeightedScore()
  }
}

// Helper to round number
Number.prototype.round = function(places) {
  return +(Math.round(this + "e+" + places) + "e-" + places);
}
