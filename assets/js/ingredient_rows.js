// ingredient_rows.js
// Handles dynamic ingredient row management for the product form

// 1. State: Track ingredient rows and available ingredients
// 2. Render: Render rows into #ingredient-rows-container
// 4. Add/Remove: Add and remove ingredient rows
// 5. Modal Integration: Add new ingredient to dropdowns and highlight row
// 6. Validation: Show inline errors per row (to be implemented)

// --- INITIAL IMPLEMENTATION ---

document.addEventListener('DOMContentLoaded', function() {
  // Read ingredient options from the hidden div
  const ingredientDataDiv = document.getElementById('ingredient-options-data');
  if (!ingredientDataDiv) return;
  const ingredientOptions = JSON.parse(ingredientDataDiv.dataset.ingredients || '[]');

  // Read ingredient errors from the hidden div
  const ingredientErrorsDiv = document.getElementById('ingredient-errors-data');
  const ingredientErrors = ingredientErrorsDiv ? JSON.parse(ingredientErrorsDiv.dataset.ingredientErrors || '{}') : {};

  // Read selected ingredients data from hidden divs
  const selectedIngredientsDiv = document.getElementById('selected-ingredients-data');
  const selectedIngredients = selectedIngredientsDiv ? JSON.parse(selectedIngredientsDiv.dataset.selectedIngredients || '[]') : [];
  const ingredientDosages = selectedIngredientsDiv ? JSON.parse(selectedIngredientsDiv.dataset.ingredientDosages || '{}') : {};
  const ingredientUnits = selectedIngredientsDiv ? JSON.parse(selectedIngredientsDiv.dataset.ingredientUnits || '{}') : {};

  // State: array of ingredient row objects
  let ingredientRows = [];

  // Helper to generate a unique row ID
  let nextRowId = 1;
  function generateRowId() {
    return nextRowId++;
  }

  // Initialize rows with existing data
  if (selectedIngredients.length > 0) {
    selectedIngredients.forEach(ingredientId => {
      addRow({
        ingredient_id: ingredientId,
        dosage: ingredientDosages[ingredientId] || '',
        unit: ingredientUnits[ingredientId] || 'mg'
      });
    });
  } else {
    // If no existing ingredients, add one empty row
    addRow();
  }

  // Render all rows
  function renderRows() {
    const container = document.getElementById('ingredient-rows-container');
    container.innerHTML = '';
    if (ingredientRows.length === 0) {
      addRow();
      return;
    }
    ingredientRows.forEach((row, idx) => {
      const rowDiv = document.createElement('div');
      rowDiv.className = 'flex items-center space-x-3 p-4 bg-base-100 rounded-lg border border-base-300 ingredient-row';
      rowDiv.dataset.rowId = row.id;

      // Find errors for this row (by ingredient_id if present)
      let rowErrors = {};
      if (row.ingredient_id && ingredientErrors[row.ingredient_id]) {
        rowErrors = ingredientErrors[row.ingredient_id];
      }

      rowDiv.innerHTML = `
        <div class="flex flex-col flex-1">
          <label class="block text-xs font-medium text-base-content">Name</label>
          <select class="ingredient-select w-full${rowErrors.dosage_ingredient ? ' border-red-500' : ''}" data-row-id="${row.id}">
            <option value="">Select ingredient...</option>
            ${ingredientOptions.map(opt => `<option value="${opt.id}" ${row.ingredient_id == opt.id ? 'selected' : ''}>${opt.name}</option>`).join('')}
          </select>
          ${rowErrors.dosage_ingredient ? `<span class='text-xs text-red-500 mt-1'>${rowErrors.dosage_ingredient[0]}</span>` : ''}
        </div>
        <div class="flex flex-col">
          <label class="block text-xs font-medium text-base-content">Dosage</label>
          <input type="number" step="0.01" class="ingredient-dosage ml-1 w-24 rounded-md border-base-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm text-base-content bg-base-100 placeholder:text-base-content/70${rowErrors.dosage_amount ? ' border-red-500' : ''}" placeholder="Amount" value="${row.dosage || ''}" data-row-id="${row.id}" />
          ${rowErrors.dosage_amount ? `<span class='text-xs text-red-500 mt-1'>${rowErrors.dosage_amount[0]}</span>` : ''}
        </div>
        <div class="flex flex-col">
          <label class="block text-xs font-medium text-base-content">Unit</label>
          <select class="ingredient-unit w-16 rounded-md border-base-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm text-base-content bg-base-100${rowErrors.dosage_unit ? ' border-red-500' : ''}" data-row-id="${row.id}">
            <option value="mg" ${row.unit === 'mg' ? 'selected' : ''}>mg</option>
            <option value="g" ${row.unit === 'g' ? 'selected' : ''}>g</option>
            <option value="mcg" ${row.unit === 'mcg' ? 'selected' : ''}>mcg</option>
          </select>
          ${rowErrors.dosage_unit ? `<span class='text-xs text-red-500 mt-1'>${rowErrors.dosage_unit[0]}</span>` : ''}
        </div>
        <button type="button" class="remove-ingredient-row btn btn-ghost btn-xs" data-row-id="${row.id}" title="Remove row" ${ingredientRows.length === 1 ? 'disabled' : ''}>&times;</button>
      `;
      container.appendChild(rowDiv);
    });
    // Add event listeners
    container.querySelectorAll('.remove-ingredient-row').forEach(btn => {
      btn.addEventListener('click', function(e) {
        const rowId = parseInt(e.target.dataset.rowId, 10);
        removeRow(rowId);
      });
    });
    container.querySelectorAll('.ingredient-select').forEach(select => {
      select.addEventListener('change', function(e) {
        const rowId = parseInt(e.target.dataset.rowId, 10);
        const value = e.target.value;
        updateRow(rowId, { ingredient_id: value });
      });
    });
    container.querySelectorAll('.ingredient-dosage').forEach(input => {
      input.addEventListener('input', function(e) {
        const rowId = parseInt(e.target.dataset.rowId, 10);
        updateRow(rowId, { dosage: e.target.value });
      });
    });
    container.querySelectorAll('.ingredient-unit').forEach(select => {
      select.addEventListener('change', function(e) {
        const rowId = parseInt(e.target.dataset.rowId, 10);
        updateRow(rowId, { unit: e.target.value });
      });
    });
  }

  // Add a new row
  function addRow(initial = {}) {
    ingredientRows.push({
      id: generateRowId(),
      ingredient_id: initial.ingredient_id || '',
      dosage: initial.dosage || '',
      unit: initial.unit || 'mg',
    });
    renderRows();
  }

  // Remove a row
  function removeRow(rowId) {
    ingredientRows = ingredientRows.filter(row => row.id !== rowId);
    renderRows();
  }

  // Update a row
  function updateRow(rowId, changes) {
    ingredientRows = ingredientRows.map(row =>
      row.id === rowId ? { ...row, ...changes } : row
    );
  }

  // Add row button
  const addRowBtn = document.getElementById('add-ingredient-row');
  if (addRowBtn) {
    addRowBtn.addEventListener('click', function() {
      addRow();
    });
  }

  // Initial render
  renderRows();

  // --- MODAL INTEGRATION ---
  // Listen for a custom event when a new ingredient is created via the modal
  window.addEventListener('ingredient:created', function(e) {
    const newIngredient = e.detail;
    // Add to ingredient options
    ingredientOptions.push(newIngredient);
    // Add a new row with the new ingredient pre-selected
    addRow({ ingredient_id: newIngredient.id });
    // Highlight the new row
    setTimeout(() => {
      const container = document.getElementById('ingredient-rows-container');
      const lastRow = container.lastElementChild;
      if (lastRow) {
        lastRow.classList.add('ingredient-highlight');
        setTimeout(() => {
          lastRow.classList.remove('ingredient-highlight');
        }, 2000);
      }
    }, 100);
    // Update all select dropdowns with the new option
    updateAllSelects();
  });

  // Helper to update all select dropdowns with the latest options
  function updateAllSelects() {
    document.querySelectorAll('.ingredient-select').forEach(select => {
      const currentValue = select.value;
      select.innerHTML = ingredientOptions.map(opt => 
        `<option value="${opt.id}" ${currentValue == opt.id ? 'selected' : ''}>${opt.name}</option>`
      ).join('');
    });
  }

  // --- FORM SUBMISSION HANDLING ---
  // Find the product form
  const productForm = document.querySelector('form[action][method="post"], form[action]:not([method])');
  if (productForm) {
    productForm.addEventListener('submit', function(e) {
      // Remove any previously added hidden ingredient inputs
      Array.from(productForm.querySelectorAll('.js-ingredient-hidden')).forEach(el => el.remove());
      // Only include rows with an ingredient selected
      const validRows = ingredientRows.filter(row => row.ingredient_id && row.ingredient_id !== '');
      validRows.forEach((row, idx) => {
        // ingredient_id
        const inputId = document.createElement('input');
        inputId.type = 'hidden';
        inputId.name = `product[ingredients][${idx}][ingredient_id]`;
        inputId.value = row.ingredient_id;
        inputId.className = 'js-ingredient-hidden';
        productForm.appendChild(inputId);
        // dosage
        const inputDosage = document.createElement('input');
        inputDosage.type = 'hidden';
        inputDosage.name = `product[ingredients][${idx}][dosage]`;
        inputDosage.value = row.dosage;
        inputDosage.className = 'js-ingredient-hidden';
        productForm.appendChild(inputDosage);
        // unit
        const inputUnit = document.createElement('input');
        inputUnit.type = 'hidden';
        inputUnit.name = `product[ingredients][${idx}][unit]`;
        inputUnit.value = row.unit;
        inputUnit.className = 'js-ingredient-hidden';
        productForm.appendChild(inputUnit);
      });
    });
  }
}); 