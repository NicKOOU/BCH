import { ethers } from "ethers";
import VehicleMaintenanceArtifact from "../artifacts/contracts/CarMaintenanceContract.sol/VehicleMaintenance.json";

const provider = new ethers.JsonRpcProvider("http://127.0.0.1:8545");
const signer = provider.getSigner();

const contractAddress = "0x5fbdb2315678afecb367f032d93f642f64180aa3";
const vehicleMaintenanceContract = new ethers.Contract(
    contractAddress,
    VehicleMaintenanceArtifact.abi,
    signer
);

export default {
    async registerVehicle(vehicleOwner) {
        await vehicleMaintenanceContract.registerVehicle(vehicleOwner);
        return "Vehicle successfully registered";
    },
    // Add other contract interaction methods here
};
