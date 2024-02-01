import fs from 'fs';

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

