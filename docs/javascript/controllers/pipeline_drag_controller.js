import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["column"]

  connect() {
    this.element.addEventListener("dragstart", this.dragStart.bind(this))
    this.element.addEventListener("dragover", this.dragOver.bind(this))
    this.element.addEventListener("dragleave", this.dragLeave.bind(this))
    this.element.addEventListener("drop", this.drop.bind(this))
  }

  dragStart(event) {
    const card = event.target.closest("[data-application-id]")
    if (!card) return

    event.dataTransfer.setData("text/plain", card.dataset.applicationId)
    event.dataTransfer.effectAllowed = "move"
    card.classList.add("opacity-30", "scale-95")
  }

  dragOver(event) {
    const column = event.target.closest("[data-stage-id]")
    if (!column) return

    event.preventDefault()
    event.dataTransfer.dropEffect = "move"
    column.classList.add("border-orange-500", "bg-neutral-900")
  }

  dragLeave(event) {
    const column = event.target.closest("[data-stage-id]")
    if (!column) return

    column.classList.remove("border-orange-500", "bg-neutral-900")
  }

  async drop(event) {
    event.preventDefault()

    const column = event.target.closest("[data-stage-id]")
    if (!column) return

    column.classList.remove("border-orange-500", "bg-neutral-900")

    const applicationId = event.dataTransfer.getData("text/plain")
    const targetStageId = column.dataset.stageId

    if (!applicationId || !targetStageId) return

    await this.moveCandidate(applicationId, targetStageId)
  }

  async selectStage(event) {
    const select = event.target
    const applicationId = select.dataset.applicationId
    const targetStageId = select.value

    if (applicationId && targetStageId) {
      await this.moveCandidate(applicationId, targetStageId)
    }
  }

  async moveCandidate(applicationId, targetStageId) {
    const csrfToken = document.querySelector("meta[name='csrf-token']")?.content

    try {
      const response = await fetch(`/candidate_applications/${applicationId}/update_stage`, {
        method: "PATCH",
        headers: {
          "Content-Type": "application/json",
          "Accept": "text/html, application/json",
          "X-CSRF-Token": csrfToken || ""
        },
        body: JSON.stringify({ target_stage_id: targetStageId })
      })

      if (response.ok) {
        // Reload page to reflect updated pipeline stage
        window.location.reload()
      } else {
        console.error("Stage update failed with status:", response.status)
      }
    } catch (err) {
      console.error("Stage move network error:", err)
    }
  }
}
