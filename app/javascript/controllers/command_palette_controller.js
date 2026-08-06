import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal", "input", "resultsContainer"]

  connect() {
    this.handleKeyDown = this.handleKeyDown.bind(this)
    window.addEventListener("keydown", this.handleKeyDown)
    this.timeout = null
  }

  disconnect() {
    window.removeEventListener("keydown", this.handleKeyDown)
  }

  handleKeyDown(event) {
    if ((event.metaKey || event.ctrlKey) && event.key.toLowerCase() === "k") {
      event.preventDefault()
      this.toggle()
    } else if (event.key === "Escape" && !this.modalTarget.classList.contains("hidden")) {
      this.close()
    }
  }

  toggle() {
    if (this.modalTarget.classList.contains("hidden")) {
      this.open()
    } else {
      this.close()
    }
  }

  open() {
    this.modalTarget.classList.remove("hidden")
    this.inputTarget.focus()
    this.inputTarget.value = ""
    this.resultsContainerTarget.innerHTML = `<p class="text-xs text-slate-400 p-3">Type to search job postings or candidates...</p>`
  }

  close() {
    this.modalTarget.classList.add("hidden")
  }

  search() {
    clearTimeout(this.timeout)
    const query = this.inputTarget.value.trim()

    if (query.length === 0) {
      this.resultsContainerTarget.innerHTML = `<p class="text-xs text-slate-400 p-3">Type to search job postings or candidates...</p>`
      return
    }

    this.timeout = setTimeout(async () => {
      try {
        const response = await fetch(`/search?q=${encodeURIComponent(query)}`)
        const data = await response.json()

        let html = ""

        if (data.job_postings.length > 0) {
          html += `<div class="px-3 py-1.5 text-xs font-semibold text-slate-400 uppercase tracking-wider bg-slate-800/50">Job Postings</div>`
          data.job_postings.forEach(job => {
            html += `
              <a href="${job.url}" data-action="click->command-palette#close" class="flex items-center justify-between px-3 py-2 text-sm text-slate-200 hover:bg-indigo-600/30 hover:text-white rounded group">
                <span class="font-medium">${job.title}</span>
                <span class="text-xs text-slate-400 group-hover:text-indigo-200">${job.department}</span>
              </a>
            `
          })
        }

        if (data.candidates.length > 0) {
          html += `<div class="px-3 py-1.5 text-xs font-semibold text-slate-400 uppercase tracking-wider bg-slate-800/50 border-t border-slate-800">Candidates</div>`
          data.candidates.forEach(cand => {
            html += `
              <a href="${cand.url}" data-action="click->command-palette#close" class="flex items-center justify-between px-3 py-2 text-sm text-slate-200 hover:bg-indigo-600/30 hover:text-white rounded group">
                <span class="font-medium">${cand.name}</span>
                <span class="text-xs text-slate-400 group-hover:text-indigo-200">${cand.email}</span>
              </a>
            `
          })
        }

        if (data.job_postings.length === 0 && data.candidates.length === 0) {
          html = `<p class="text-xs text-slate-400 p-3">No matching jobs or candidates found.</p>`
        }

        this.resultsContainerTarget.innerHTML = html
      } catch (err) {
        console.error("Search failed:", err)
      }
    }, 200)
  }
}
