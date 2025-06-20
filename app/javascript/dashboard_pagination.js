// Dashboard widgets pagination handler
document.addEventListener('DOMContentLoaded', function() {
  // Handle pagination clicks for all widgets - be more specific to avoid conflicts
  document.addEventListener('click', function(event) {
    // Only handle clicks on pagination links inside widgets
    const link = event.target.closest('.widget-content .pagination a');
    if (!link) return;

    // Check if it's inside a widget
    const widgetContent = link.closest('.widget-content');
    if (!widgetContent) return;

    event.preventDefault();
    event.stopPropagation(); // Prevent event bubbling

    const widgetId = widgetContent.id;

    // Show loading state
    widgetContent.style.opacity = '0.6';

    // Determine which endpoint to call based on widget
    let endpoint;
    if (widgetId.includes('overdue-expenses')) {
      endpoint = '/dashboard/load_overdue_expenses';
    } else if (widgetId.includes('pending-income')) {
      endpoint = '/dashboard/load_pending_income';
    } else if (widgetId.includes('upcoming-expenses')) {
      endpoint = '/dashboard/load_upcoming_expenses';
    } else if (widgetId.includes('upcoming-income')) {
      endpoint = '/dashboard/load_upcoming_income';
    }

    if (endpoint) {
        const url = new URL(link.href);
      const queryParams = url.search; // Gets ?page=2 etc.
      const fullEndpoint = endpoint + queryParams;

      fetch(fullEndpoint, {
        headers: {
          'Accept': 'text/html',
          'X-Requested-With': 'XMLHttpRequest'
        }
      })
      .then(response => response.text())
      .then(html => {
        widgetContent.innerHTML = html;
        widgetContent.style.opacity = '1';
      })
      .catch(error => {
        console.error('Error loading widget content:', error);
        widgetContent.style.opacity = '1';
      });
    }
  });
});
