import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "recurringCheckbox",
    "frequencyDiv",
    "transactionTypeSelect",
    "categorySelect"
  ]

  connect() {
    this.setupRecurringToggle()
    this.setupCategoryFiltering()
  }

  setupRecurringToggle() {
    if (this.hasRecurringCheckboxTarget) {
      this.recurringCheckboxTarget.addEventListener('change', this.toggleFrequencyField.bind(this))
    }
  }

  setupCategoryFiltering() {
    if (this.hasTransactionTypeSelectTarget && this.hasCategorySelectTarget) {
      this.storeCategoryOptions()
      this.transactionTypeSelectTarget.addEventListener('change', this.onTransactionTypeChange.bind(this))
      this.categorySelectTarget.addEventListener('change', this.onCategoryChange.bind(this))
    }
  }

  toggleFrequencyField() {
    if (this.hasFrequencyDivTarget) {
      this.frequencyDivTarget.style.display = this.recurringCheckboxTarget.checked ? 'block' : 'none'
    }
  }

  storeCategoryOptions() {
    this.allCategoryOptions = Array.from(this.categorySelectTarget.options).map(option => ({
      value: option.value,
      text: option.text,
      categoryType: option.dataset.categoryType
    }))
  }

  onTransactionTypeChange() {
    this.disablePromptOption()
    this.updateCategorySelect()
  }

  onCategoryChange() {
    this.disableCategoryPromptOption()
  }

  disablePromptOption() {
    const promptOption = this.transactionTypeSelectTarget.querySelector('option[value=""]')
    if (promptOption && this.transactionTypeSelectTarget.value !== '') {
      promptOption.disabled = true
    }
  }

  disableCategoryPromptOption() {
    const promptOption = this.categorySelectTarget.querySelector('option[value=""]')
    if (promptOption && this.categorySelectTarget.value !== '') {
      promptOption.disabled = true
    }
  }

  updateCategorySelect() {
    const selectedType = this.transactionTypeSelectTarget.value

    this.categorySelectTarget.innerHTML = ''

    if (!selectedType) {
      this.categorySelectTarget.disabled = true
      this.addPromptOption('Selecione Primeiro o Tipo')
    } else {
      this.categorySelectTarget.disabled = false
      this.addPromptOption('Selecione uma categoria')
      this.addFilteredCategoryOptions(selectedType)
    }
  }

  addPromptOption(promptText) {
    const promptOption = document.createElement('option')
    promptOption.value = ''
    promptOption.text = promptText
    this.categorySelectTarget.appendChild(promptOption)
  }

  addFilteredCategoryOptions(selectedType) {
    this.allCategoryOptions
      .filter(option => option.categoryType === selectedType && option.value !== '')
      .forEach(option => {
        const optionElement = document.createElement('option')
        optionElement.value = option.value
        optionElement.text = option.text
        this.categorySelectTarget.appendChild(optionElement)
      })
  }
}
