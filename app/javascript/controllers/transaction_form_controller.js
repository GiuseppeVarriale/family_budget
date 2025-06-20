import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="transaction-form"
export default class extends Controller {
  static targets = [
    "recurringCheckbox",
    "frequencyDiv"
  ]

  connect() {
    this.setupRecurringToggle()
  }

  setupRecurringToggle() {
    if (this.hasRecurringCheckboxTarget) {
      this.recurringCheckboxTarget.addEventListener('change', this.toggleFrequencyField.bind(this))
    }
  }

  toggleFrequencyField() {
    if (this.hasFrequencyDivTarget) {
      this.frequencyDivTarget.style.display = this.recurringCheckboxTarget.checked ? 'block' : 'none'
    }
  }
}
