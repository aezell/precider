// ingredient_modal.js
// Handles the ingredient modal open/close and form submission for adding a new ingredient

document.addEventListener('DOMContentLoaded', function() {
  const modal = document.getElementById('ingredient-modal');
  const openButton = document.querySelector('[phx-click="open_ingredient_modal"]');
  const closeButton = document.querySelector('[phx-click="close_ingredient_modal"]');
  const ingredientForm = document.getElementById('ingredient-form');

  if (openButton && closeButton && modal) {
    openButton.addEventListener('click', function() {
      modal.classList.remove('hidden');
    });
    closeButton.addEventListener('click', function() {
      modal.classList.add('hidden');
    });
  }

  if (ingredientForm) {
    ingredientForm.addEventListener('submit', async function(e) {
      e.preventDefault();
      const formData = new FormData(ingredientForm);
      try {
        const response = await fetch(ingredientForm.action, {
          method: 'POST',
          body: formData,
          headers: {
            'Accept': 'application/json'
          }
        });
        const data = await response.json();
        if (response.ok && data.success && data.ingredient) {
          // Close the modal
          modal.classList.add('hidden');
          // Dispatch the custom event for the new ingredient
          window.dispatchEvent(new CustomEvent('ingredient:created', {
            detail: {
              id: data.ingredient.id,
              name: data.ingredient.name
            }
          }));
          // Optionally reset the form
          ingredientForm.reset();
        } else {
          alert('Error creating ingredient: ' + (data.errors || 'Unknown error'));
        }
      } catch (error) {
        console.error('Error:', error);
        alert('Error creating ingredient. Please try again.');
      }
    });
  }
}); 