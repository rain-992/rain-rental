let vehicles = [];

window.addEventListener('message', function(event) {
    if (event.data.action === "openRental") {
        vehicles = event.data.vehicles;
        document.getElementById('rental-container').classList.remove('hidden');
        renderVehicles();
    }
});

function renderVehicles() {
    const vehiclesList = document.getElementById('vehicles-list');
    vehiclesList.innerHTML = '';
    
    vehicles.forEach(vehicle => {
        const card = document.createElement('div');
        card.className = 'vehicle-card';
        card.innerHTML = `
            <img src="${vehicle.image}" class="vehicle-image" alt="${vehicle.label}">
            <h3>${vehicle.label}</h3>
            <p>每小时租金: $${vehicle.price}</p>
            <select class="time-select">
                <option value="1">1小时</option>
                <option value="2">2小时</option>
                <option value="4">4小时</option>
                <option value="8">8小时</option>
            </select>
            <button class="rent-button" onclick="rentVehicle('${vehicle.model}', this)">租赁</button>
        `;
        vehiclesList.appendChild(card);
    });
}

function rentVehicle(model, button) {
    const timeSelect = button.previousElementSibling;
    const time = parseInt(timeSelect.value);
    const vehicle = vehicles.find(v => v.model === model);
    
    fetch(`https://${GetParentResourceName()}/rentVehicle`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            model: model,
            time: time,
            price: vehicle.price
        })
    });
    
    closeMenu();
}

function closeMenu() {
    document.getElementById('rental-container').classList.add('hidden');
    fetch(`https://${GetParentResourceName()}/closeMenu`, {
        method: 'POST'
    });
}