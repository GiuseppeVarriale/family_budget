// Dashboard transaction modals functionality
// Handles category tooltips and recurring transaction controls

class DashboardModals {
  constructor() {
    // Use a longer timeout for Turbo navigation scenarios
    if (document.readyState === 'loading') {
      document.addEventListener('DOMContentLoaded', () => {
        setTimeout(() => this.init(), 100);
      });
    } else {
      // DOM is already loaded, but wait longer to ensure all elements are rendered
      setTimeout(() => this.init(), 100);
    }
  }

  init() {
    // Double-check elements exist before binding
    if (this.hasRequiredElements()) {
      this.bindCategoryTooltips();
      this.bindRecurringControls();
      this.bindModalResetEvents();
      this.initializeTooltipsOnLoad();
    }
  }

  // Check if required modal elements exist
  hasRequiredElements() {
    return document.getElementById('incomeModal') || document.getElementById('expenseModal');
  }

  // Initialize tooltips for already selected categories on page load
  initializeTooltipsOnLoad() {
    const incomeCategorySelect = document.getElementById('income_category_select');
    const incomeCategoryTooltip = document.getElementById('income_category_tooltip');

    if (incomeCategorySelect && incomeCategoryTooltip && incomeCategorySelect.value) {
      this.updateCategoryTooltip(incomeCategorySelect, incomeCategoryTooltip);
    }

    const expenseCategorySelect = document.getElementById('expense_category_select');
    const expenseCategoryTooltip = document.getElementById('expense_category_tooltip');

    if (expenseCategorySelect && expenseCategoryTooltip && expenseCategorySelect.value) {
      this.updateCategoryTooltip(expenseCategorySelect, expenseCategoryTooltip);
    }
  }

  // Function to update category tooltip
  updateCategoryTooltip(selectElement, tooltipElement) {
    const selectedOption = selectElement.options[selectElement.selectedIndex];

    if (selectedOption && selectedOption.getAttribute('data-description')) {
      const description = selectedOption.getAttribute('data-description');
      const tooltipIcon = tooltipElement.querySelector('i');

      if (tooltipIcon) {
        tooltipIcon.setAttribute('title', description);
        tooltipIcon.setAttribute('data-bs-original-title', description);

        tooltipElement.style.display = 'inline-block';

        // Dispose existing tooltip first to avoid duplicates
        if (window.bootstrap && bootstrap.Tooltip) {
          const existingTooltip = bootstrap.Tooltip.getInstance(tooltipIcon);
          if (existingTooltip) {
            existingTooltip.dispose();
          }

          // Initialize Bootstrap tooltip with delay to ensure Bootstrap is ready
          setTimeout(() => {
            if (window.bootstrap && bootstrap.Tooltip) {
              new bootstrap.Tooltip(tooltipIcon);
            }
          }, 50);
        }
      }
    } else {
      tooltipElement.style.display = 'none';

      // Dispose tooltip if hidden
      const tooltipIcon = tooltipElement.querySelector('i');
      if (tooltipIcon && window.bootstrap && bootstrap.Tooltip) {
        const existingTooltip = bootstrap.Tooltip.getInstance(tooltipIcon);
        if (existingTooltip) {
          existingTooltip.dispose();
        }
      }
    }
  }

  bindCategoryTooltips() {
    // Income category select handler
    const incomeCategorySelect = document.getElementById('income_category_select');
    const incomeCategoryTooltip = document.getElementById('income_category_tooltip');

    if (incomeCategorySelect && incomeCategoryTooltip) {
      incomeCategorySelect.addEventListener('change', () => {
        this.updateCategoryTooltip(incomeCategorySelect, incomeCategoryTooltip);
      });
    }

    // Expense category select handler
    const expenseCategorySelect = document.getElementById('expense_category_select');
    const expenseCategoryTooltip = document.getElementById('expense_category_tooltip');

    if (expenseCategorySelect && expenseCategoryTooltip) {
      expenseCategorySelect.addEventListener('change', () => {
        this.updateCategoryTooltip(expenseCategorySelect, expenseCategoryTooltip);
      });
    }
  }

  bindRecurringControls() {
    // Toggle recurring frequency fields
    const recurringCheckboxes = document.querySelectorAll('input[name="transaction[is_recurring]"]');

    recurringCheckboxes.forEach((checkbox) => {
      checkbox.addEventListener('change', function() {
        const modal = this.closest('.modal');
        const frequencyDiv = modal.querySelector('[id^="recurring-frequency"]');

        if (this.checked) {
          frequencyDiv.style.display = 'block';
        } else {
          frequencyDiv.style.display = 'none';
        }
      });
    });
  }

  bindModalResetEvents() {
    // Reset modals when closed
    const incomeModal = document.getElementById('incomeModal');
    const expenseModal = document.getElementById('expenseModal');

    if (incomeModal) {
      incomeModal.addEventListener('hidden.bs.modal', () => {
        const tooltip = document.getElementById('income_category_tooltip');
        if (tooltip) {
          tooltip.style.display = 'none';
          // Dispose tooltip
          const tooltipIcon = tooltip.querySelector('i');
          if (tooltipIcon) {
            const existingTooltip = bootstrap.Tooltip.getInstance(tooltipIcon);
            if (existingTooltip) {
              existingTooltip.dispose();
            }
          }
        }
      });
    }

    if (expenseModal) {
      expenseModal.addEventListener('hidden.bs.modal', () => {
        const tooltip = document.getElementById('expense_category_tooltip');
        const frequencyDiv = document.getElementById('recurring-frequency-expense');

        if (tooltip) {
          tooltip.style.display = 'none';
          // Dispose tooltip
          const tooltipIcon = tooltip.querySelector('i');
          if (tooltipIcon) {
            const existingTooltip = bootstrap.Tooltip.getInstance(tooltipIcon);
            if (existingTooltip) {
              existingTooltip.dispose();
            }
          }
        }

        if (frequencyDiv) {
          frequencyDiv.style.display = 'none';
        }
      });
    }
  }
}

// Global instance to avoid duplicates
let dashboardModalsInstance = null;

// Initialize on different events to handle various scenarios
function initializeDashboardModals() {
  // Reset instance on Turbo navigation to ensure fresh bindings
  dashboardModalsInstance = null;

  // Only initialize if we're on a page that has the modals
  if (document.getElementById('incomeModal') || document.getElementById('expenseModal')) {
    dashboardModalsInstance = new DashboardModals();
  }
}

// Initialize when DOM is ready
document.addEventListener('DOMContentLoaded', initializeDashboardModals);

// Initialize on Turbo events (for SPA-like navigation)
document.addEventListener('turbo:load', initializeDashboardModals);
document.addEventListener('turbo:render', initializeDashboardModals);

export default DashboardModals;
