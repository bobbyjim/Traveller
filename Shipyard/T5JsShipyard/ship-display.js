// main.js

// Define the ship template object
const shipTemplate = {
	format: "T5-ACS-2",
	header: {
	  tonnage: 500,
	  TL: 15,
	  missionCode: "X",
	  hullCode: "SDB",
	  shipName: "Example Ship",
	  createdOn: new Date(),
	  missionLabel: "Exploration",
	  allegiance: "Imperial",
	  builder: "Imperial Navy",
	  firstFlightOn: new Date(),
	},
	rollup: {
	  jump: 2,
	  power: 200,
	  maneuver: 2,
	  duration: 6,
	  QSP: 3,
	  MCr: 50,
	  armorValue: 10,
	},
	components: [
	  {
		name: "Armor",
		type: "Hull",
		volume: 100,
		cost: 10,
		controlPointRating: 5,
		accommodationNumber: 100,
		code: "ARM01",
	  },
	  {
		name: "Jump Drive",
		type: "Propulsion",
		volume: 50,
		cost: 20,
		controlPointRating: 4,
		accommodationNumber: 50,
		code: "JD01",
	  },
	  {
		name: "Laser Cannon",
		type: "Weapon",
		volume: 10,
		cost: 5,
		controlPointRating: 2,
		accommodationNumber: 20,
		code: "LC01",
	  },
	  // Add more components as needed
	]
  };
  
  // Function to generate HTML for displaying ship components
  function generateShipHTML(shipTemplate) {
	const shipDisplayDiv = document.getElementById("shipDisplay");
	const table = document.createElement("table");
  
	// Create table headers
	const headers = ["Name", "Type", "Volume", "Cost", "Control Point Rating", "Accommodation Number", "Code", "Edit"];
	const headerRow = document.createElement("tr");
	headers.forEach(headerText => {
	  const th = document.createElement("th");
	  th.textContent = headerText;
	  headerRow.appendChild(th);
	});
	table.appendChild(headerRow);
  
	// Add rows for each ship component
	shipTemplate.components.forEach((component, index) => {
	  const row = document.createElement("tr");
  
	  // Add cells for component properties
	  Object.values(component).forEach(value => {
		const cell = document.createElement("td");
		cell.textContent = value;
		row.appendChild(cell);
	  });
  
	  // Add edit button
	  const editCell = document.createElement("td");
	  const editButton = document.createElement("button");
	  editButton.textContent = "Edit";
	  editButton.addEventListener("click", () => openItemEditor(index)); // Pass component index to the edit function
	  editCell.appendChild(editButton);
	  row.appendChild(editCell);
  
	  table.appendChild(row);
	});
  
	// Append table to div
	shipDisplayDiv.innerHTML = "";
	shipDisplayDiv.appendChild(table);
  }
  
  // Function to open item editor for a selected component
  function openItemEditor(index) {
	// Get selected component from ship template
	const selectedComponent = shipTemplate.components[index];
	console.log("Editing component:", selectedComponent);
  
	// Determine component type and call corresponding item editor function
	switch (selectedComponent.type) {
	  case "Weapon":
		openWeaponEditor(selectedComponent);
		break;
	  // Add cases for other component types as needed
	  default:
		console.log("No item editor available for component type:", selectedComponent.type);
	}
  }
  
  // Function to open item editor for a Weapon component
  function openWeaponEditor(component) {
	// Clear previous item editor content
	const itemEditorDiv = document.getElementById("itemEditor");
	itemEditorDiv.innerHTML = "";
  
	// Create form for editing Weapon component properties
	const form = document.createElement("form");
  
	// Add input fields for each property
	const nameLabel = document.createElement("label");
	nameLabel.textContent = "Name:";
	const nameInput = document.createElement("input");
	nameInput.type = "text";
	nameInput.value = component.name;
	// Add more input fields for other properties (type, volume, cost, etc.)
  
	// Append input fields to form
	form.appendChild(nameLabel);
	form.appendChild(nameInput);
	// Append more input fields for other properties
  
	// Add submit button
	const submitButton = document.createElement("button");
	submitButton.type = "submit";
	submitButton.textContent = "Save";
	form.appendChild(submitButton);
  
	// Append form to item editor div
	itemEditorDiv.appendChild(form);
  }
  
  // Initial ship HTML generation
  generateShipHTML(shipTemplate);
  