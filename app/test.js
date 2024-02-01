const Web3 = require('web3');
const fs = require('fs');

// Mettez à jour avec l'adresse du contrat déployé
const contractAddress = '0x5FbDB2315678afecb367f032d93F642f64180aa3';

// Mettez à jour avec les adresses des participants
const manufacturer = '0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266';
const dealer = '0x70997970C51812dc3A010C7d01b50e0d17dc79C8';
const client = '0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC';
const mechanic = '0x90F79bf6EB2c4f870365E785982E1f101E93b906';
const insurer = '0x15d34AAf54267DB7D7c367839AAf71A00a2C6A65';
const prefecture = '0x9965507D1a55bcC2695C58ba16FB37d819B0A4dc';
const police = '0x976EA74026E726554dB657fA54763abd0C3a0aa9';

// Charger le fichier ABI du contrat
const contractABI = JSON.parse(fs.readFileSync('./src/artifacts/contracts/CarMaintenanceContract.sol/VehicleMaintenance.json', 'utf8'));

// Créer une instance Web3
const web3 = new Web3('http://127.0.0.1:8545/');

// Créer une instance du contrat
const vehicleMaintenanceContract = new web3.eth.Contract(contractABI.abi, contractAddress);

// Fonction pour gérer les événements du contrat
function handleEvent(event) {
    console.log(`Event ${event.event} received for ${event.returnValues.owner} at timestamp ${event.returnValues.timestamp}`);
}

// Fonctions pour tester le contrat
async function testContract() {
    try {
        // Enregistrement du véhicule par le fabricant
        await vehicleMaintenanceContract.methods.registerVehicle(client, "92TETE").send({ from: manufacturer });

        // Demande d'entretien préventif par le client
        await vehicleMaintenanceContract.methods.requestPreventiveMaintenance("92TETE").send({ from: client });

        // Rapport d'un problème par le client
        await vehicleMaintenanceContract.methods.reportIssue("92TETE").send({ from: client });

        // Validation de la réparation par le mécanicien
        await vehicleMaintenanceContract.methods.validateRepair("92TETE").send({ from: mechanic });

        // Accès aux données pour l'assurance
        await vehicleMaintenanceContract.methods.accessDataForInsurance("92TETE").call({ from: insurer });

        // Accès à l'historique de maintenance
        const maintenanceHistory = await vehicleMaintenanceContract.methods.accessMaintenanceHistory("92TETE").call({ from: client });
        console.log('Maintenance History:', maintenanceHistory);

        // Évaluation de la valeur du véhicule pour la revente par le concessionnaire
        const vehicleValueForResale = await vehicleMaintenanceContract.methods.assessVehicleValueForResale("92TETE").call({ from: dealer });
        console.log('Vehicle Value for Resale:', vehicleValueForResale);

        // Transfert de propriété du véhicule par le client
        await vehicleMaintenanceContract.methods.transferVehicleOwnership(client, dealer, "DEL2E").send({ from: client });

        // Accès aux données pour l'enregistrement par la préfecture
        const isVehicleRegistered = await vehicleMaintenanceContract.methods.accessDataForRegistration("DEL2E").call({ from: prefecture });
        console.log('Is Vehicle Registered:', isVehicleRegistered);

        // Accès aux données pour une enquête policière
        const policeInvestigationData = await vehicleMaintenanceContract.methods.accessDataForPoliceInvestigation("DEL2E").call({ from: police });
        console.log('Police Investigation Data:', policeInvestigationData);

        // Rapport de la mise au rebut du véhicule par le client
        await vehicleMaintenanceContract.methods.reportVehicleDisposal("DEL2E").send({ from: client });

        // Exemple d'appels aux fonctions de lecture depuis JavaScript

        // Obtenez toutes les adresses des véhicules enregistrés getAllRegisteredVehicles()
        const registeredVehicles = await vehicleMaintenanceContract.methods.getAllRegisteredVehicles().call({ from: manufacturer });
        console.log('Registered Vehicles:', registeredVehicles);
        // Obtenez toutes les adresses des propriétaires de véhicules enregistrés
        const owners = await vehicleMaintenanceContract.methods.getAllVehicleOwners().call({ from: manufacturer });
        console.log('Owners:', owners);

        // getVehicleLicensePlate(address _vehicleOwner)
        const licensePlate = await vehicleMaintenanceContract.methods.getVehicleLicensePlate(manufacturer).call({ from: manufacturer });
        console.log('License Plate:', licensePlate);



    } catch (error) {
        console.error('Error:', error.message);
    }
}

// Exécutez la fonction de test du contrat
testContract();
