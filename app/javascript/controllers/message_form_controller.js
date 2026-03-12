import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input"]

  reset(event) {
    if (!event.detail.success) return

    this.element.reset()
    this.inputTarget.focus()
  }
}
