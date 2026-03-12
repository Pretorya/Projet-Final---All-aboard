import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["dialog"]

  open(event) {
    event?.preventDefault()
    this.dialogTarget.classList.remove("hidden")
    document.body.style.overflow = "hidden"
  }

  close(event) {
    event?.preventDefault()
    this.dialogTarget.classList.add("hidden")
    document.body.style.overflow = ""
  }

  closeOnEscape(event) {
    if (event.key === "Escape" && this.hasDialogTarget && !this.dialogTarget.classList.contains("hidden")) {
      this.close()
    }
  }
}
