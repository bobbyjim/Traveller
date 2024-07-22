// Populate weapon type dropdown menu
const weaponTypeSelect = document.getElementById("weaponType");
weaponsData.weapons.forEach(weapon => {
  const option = document.createElement('option');
  option.value = weapon.code;
  option.textContent = weapon.label;
  weaponTypeSelect.appendChild(option);
});

// Function to populate the range selection based on rangeSpec
function populateRangeSelection(rangeSpec) {
  // Get the select element for range
  var rangeSelect = document.getElementById("range");

  // Clear existing options
  rangeSelect.innerHTML = "";

  // Get the appropriate range list based on rangeSpec
  var rangeList = (rangeSpec === "world") ? weaponsData.ranges.world : weaponsData.ranges.space;

  // Iterate over the range list and create options
  for (var i = 0; i < rangeList.length; i++) {
      var range = rangeList[i];
      var option = document.createElement("option");
      option.value = range.code;
      option.text = range.label;
      rangeSelect.appendChild(option);
  }
}

// Event listener for weapon type selection change
var weaponSelect = document.getElementById("weaponType");
weaponSelect.addEventListener("change", function() {
    // Get the selected weapon type
    var weaponCode = this.value;

    // Find the weapon object in weaponsData
    var weapon = weaponsData.weapons.find(function(weapon) {
        return weapon.code === weaponCode;
    });

    // If weapon is found, populate the range selection based on rangeSpec
    if (weapon) {
        populateRangeSelection(weapon.rangeSpec);
    }
});

// Populate the range selection initially based on the default weapon type selection
var defaultWeaponCode = weaponSelect.value;
var defaultWeapon = weaponsData.weapons.find(function(weapon) {
    return weapon.code === defaultWeaponCode;
});

if (defaultWeapon) {
    populateRangeSelection(defaultWeapon.rangeSpec);
}

// Populate mount dropdown menu
const mountSelect = document.getElementById("mount");
weaponsData.mounts.forEach(mount => {
  const option = document.createElement("option");
  option.value = mount.code;
  option.textContent = mount.label;
  mountSelect.appendChild(option);
});

// Add event listener to form submission
const itemEditorForm = document.getElementById("itemEditorForm");
itemEditorForm.addEventListener("submit", event => {
  event.preventDefault(); // Prevent form submission
  
  // Get selected weapon type, range, and mount
  const selectedWeaponType = weaponTypeSelect.value;
  const selectedRange = rangeSelect.value;
  const selectedMount = mountSelect.value;
  
  // Create new weapon component or update existing one
  const weaponComponent = {
    name: selectedWeaponType, // Use weapon type as name
    type: "Weapon",
    volume: 10, // Example volume
    cost: 5, // Example cost
    range: selectedRange,
    mount: selectedMount
  };
  
  // Add logic to create or update weapon component
});
