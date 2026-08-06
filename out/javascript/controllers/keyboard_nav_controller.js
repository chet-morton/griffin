import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    nextUrl: String,
    prevUrl: String
  }

  connect() {
    this.handleKeyDown = this.handleKeyDown.bind(this)
    window.addEventListener("keydown", this.handleKeyDown)
  }

  disconnect() {
    window.removeEventListener("keydown", this.handleKeyDown)
  }

  handleKeyDown(event) {
    // Ignore key presses inside text inputs or textareas
    if (["INPUT", "TEXTAREA", "SELECT"].includes(document.activeElement.tagName)) {
      return
    }

    if (event.key === "j" || event.key === "J") {
      if (this.hasNextUrlValue && this.nextUrlValue.length > 0) {
        event.preventDefault()
        Turbo.visit(this.nextUrlValue)
      }
    } else if (event.key === "k" || event.key === "K") {
      if (this.hasPrevUrlValue && this.prevUrlValue.length > 0) {
        event.preventDefault()
        Turbo.visit(this.prevUrlValue)
      }
    }
  }
}
