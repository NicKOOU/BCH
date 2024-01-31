// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract VehicleMaintenance {
    address public manufacturer;
    address public dealer;
    address public client;
    address public mechanic;
    address public insurer;
    address public prefecture;
    address public police;

    struct Vehicle {
        address owner;
        bool isRegistered;
        uint256 lastServiceTimestamp;
        uint256 lastRepairTimestamp;
        bool isDisposed;
        string licensePlate; // Ajout de la plaque d'immatriculation
    }

    mapping (address => Vehicle) public vehiclesByOwner; // Utilisation de l'adresse du propriétaire comme clé
    mapping (string => address) public ownerByLicensePlate; // Associe la plaque d'immatriculation à l'adresse du propriétaire

    event PreventiveMaintenanceRequested(address indexed owner, string licensePlate, uint256 timestamp);
    event IssueReported(address indexed owner, string licensePlate, uint256 timestamp);
    event RepairValidated(address indexed owner, string licensePlate, uint256 timestamp);
    event VehicleDisposed(address indexed owner, string licensePlate, uint256 timestamp);
    event VehicleRegistered(address indexed owner, string licensePlate, uint256 timestamp);

    modifier onlyManufacturer() {
        require(msg.sender == manufacturer, "Only manufacturer can call this function");
        _;
    }

    modifier onlyDealer() {
        require(msg.sender == dealer, "Only dealer can call this function");
        _;
    }

    modifier onlyClient() {
        require(msg.sender == client, "Only client can call this function");
        _;
    }

    modifier onlyMechanic() {
        require(msg.sender == mechanic, "Only mechanic can call this function");
        _;
    }

    modifier onlyInsurer() {
        require(msg.sender == insurer, "Only insurer can call this function");
        _;
    }

    modifier onlyPrefecture() {
        require(msg.sender == prefecture, "Only prefecture can call this function");
        _;
    }

    modifier onlyPolice() {
        require(msg.sender == police, "Only police can call this function");
        _;
    }

    constructor(
        address _dealer,
        address _client,
        address _mechanic,
        address _insurer,
        address _prefecture,
        address _police
    ) {
        manufacturer = msg.sender;
        dealer = _dealer;
        client = _client;
        mechanic = _mechanic;
        insurer = _insurer;
        prefecture = _prefecture;
        police = _police;
    }

    function registerVehicle(address _vehicleOwner, string memory _licensePlate) external onlyManufacturer {
        require(!vehiclesByOwner[_vehicleOwner].isRegistered, "Vehicle is already registered");
        require(ownerByLicensePlate[_licensePlate] == address(0), "License plate is already registered");

        vehiclesByOwner[_vehicleOwner] = Vehicle(_vehicleOwner, true, 0, 0, false, _licensePlate);
        ownerByLicensePlate[_licensePlate] = _vehicleOwner;

        emit VehicleRegistered(_vehicleOwner, _licensePlate, block.timestamp);
    }

    function requestPreventiveMaintenance(string memory _licensePlate) external onlyClient {
        address _vehicleOwner = ownerByLicensePlate[_licensePlate];
        require(vehiclesByOwner[_vehicleOwner].isRegistered, "Vehicle is not registered");
        emit PreventiveMaintenanceRequested(_vehicleOwner, _licensePlate, block.timestamp);
        vehiclesByOwner[_vehicleOwner].lastServiceTimestamp = block.timestamp;
    }

    function reportIssue(string memory _licensePlate) external onlyClient {
        address _vehicleOwner = ownerByLicensePlate[_licensePlate];
        require(vehiclesByOwner[_vehicleOwner].isRegistered, "Vehicle is not registered");
        emit IssueReported(_vehicleOwner, _licensePlate, block.timestamp);
        vehiclesByOwner[_vehicleOwner].lastRepairTimestamp = block.timestamp;
    }

    function validateRepair(string memory _licensePlate) external onlyMechanic {
        address _vehicleOwner = ownerByLicensePlate[_licensePlate];
        require(vehiclesByOwner[_vehicleOwner].isRegistered, "Vehicle is not registered");
        emit RepairValidated(_vehicleOwner, _licensePlate, block.timestamp);
        vehiclesByOwner[_vehicleOwner].lastRepairTimestamp = block.timestamp;
    }

    function accessDataForInsurance(string memory _licensePlate) external onlyInsurer view {
        address _vehicleOwner = ownerByLicensePlate[_licensePlate];
        require(vehiclesByOwner[_vehicleOwner].isRegistered, "Vehicle is not registered");
        // Logic for accessing data for insurance purposes
    }

    function accessMaintenanceHistory(string memory _licensePlate) external view returns (uint256, uint256) {
        address _vehicleOwner = ownerByLicensePlate[_licensePlate];
        require(vehiclesByOwner[_vehicleOwner].isRegistered, "Vehicle is not registered");
        // Logic for accessing maintenance history
        return (vehiclesByOwner[_vehicleOwner].lastServiceTimestamp, vehiclesByOwner[_vehicleOwner].lastRepairTimestamp);
    }

    function assessVehicleValueForResale(string memory _licensePlate) external onlyDealer view returns (bool) {
        address _vehicleOwner = ownerByLicensePlate[_licensePlate];
        require(vehiclesByOwner[_vehicleOwner].isRegistered, "Vehicle is not registered");
        // Logic for assessing vehicle value for resale
        return !vehiclesByOwner[_vehicleOwner].isDisposed;
    }

    function transferVehicleOwnership(address _oldVehicleOwner, address _newOwner, string memory _newLicensePlate) external onlyClient {
        require(vehiclesByOwner[_oldVehicleOwner].isRegistered, "Vehicle is not registered");
        require(!vehiclesByOwner[_newOwner].isRegistered, "New owner must not own another registered vehicle");
        require(ownerByLicensePlate[_newLicensePlate] == address(0), "License plate is already registered");

        // Logic for transferring ownership
        vehiclesByOwner[_newOwner] = vehiclesByOwner[_oldVehicleOwner];
        vehiclesByOwner[_newOwner].owner = _newOwner;
        vehiclesByOwner[_newOwner].licensePlate = _newLicensePlate;

        ownerByLicensePlate[_newLicensePlate] = _newOwner;
        delete vehiclesByOwner[_oldVehicleOwner];
    }

    function accessDataForRegistration(string memory _licensePlate) external onlyPrefecture view returns (bool) {
        address _vehicleOwner = ownerByLicensePlate[_licensePlate];
        // Logic for accessing data for vehicle registration
        return vehiclesByOwner[_vehicleOwner].isRegistered && !vehiclesByOwner[_vehicleOwner].isDisposed;
    }

    function accessDataForPoliceInvestigation(string memory _licensePlate) external onlyPolice view returns (uint256, uint256) {
        address _vehicleOwner = ownerByLicensePlate[_licensePlate];
        require(vehiclesByOwner[_vehicleOwner].isRegistered, "Vehicle is not registered");
        // Logic for accessing data for police investigation
        return (vehiclesByOwner[_vehicleOwner].lastServiceTimestamp, vehiclesByOwner[_vehicleOwner].lastRepairTimestamp);
    }

    function reportVehicleDisposal(string memory _licensePlate) external onlyClient {
        address _vehicleOwner = ownerByLicensePlate[_licensePlate];
        require(vehiclesByOwner[_vehicleOwner].isRegistered, "Vehicle is not registered");
        emit VehicleDisposed(_vehicleOwner, _licensePlate, block.timestamp);
        // Logic for reporting vehicle disposal
        // Trigger interaction with Smart Contract
        vehiclesByOwner[_vehicleOwner].isDisposed = true;
    }

    // Ajoutez ces fonctions à votre contrat

function getAllRegisteredVehicles() external view returns (address[] memory) {
    // Retourne toutes les adresses des propriétaires de véhicules enregistrés
    address[] memory registeredOwners = new address[](1);
registeredOwners[0] = msg.sender;

    uint256 count = 0;

    for (uint256 i = 0; i < registeredOwners.length; i++) {
        if (vehiclesByOwner[registeredOwners[i]].isRegistered) {
            registeredOwners[count] = registeredOwners[i];
            count++;
        }
    }

    assembly {
        mstore(registeredOwners, count)
    }

    return registeredOwners;
}

function getVehicleLicensePlate(address _vehicleOwner) external view returns (string memory) {
    // Retourne la plaque d'immatriculation d'un véhicule enregistré
    require(vehiclesByOwner[_vehicleOwner].isRegistered, "Vehicle is not registered");
    return vehiclesByOwner[_vehicleOwner].licensePlate;
}

function getAllVehicleOwners() external view returns (address[] memory) {
    // Retourne toutes les adresses des propriétaires de véhicules
    address[] memory allOwners = new address[](1);
    allOwners[0] = msg.sender;

    uint256 count = 0;

    for (uint256 i = 0; i < allOwners.length; i++) {
        allOwners[count] = allOwners[i];
        count++;
    }

    assembly {
        mstore(allOwners, count)
    }

    return allOwners;
}


}
