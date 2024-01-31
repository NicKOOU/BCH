const { ethers } = require("hardhat");

async function main() {
    const [manufacturer, dealer, client, mechanic, insurer, prefecture, police] = await ethers.getSigners();

    console.log("Deploying contracts with the following addresses:");
    console.log("Manufacturer:", manufacturer.address);
    console.log("Dealer:", dealer.address);
    console.log("Client:", client.address);
    console.log("Mechanic:", mechanic.address);
    console.log("Insurer:", insurer.address);
    console.log("Prefecture:", prefecture.address);
    console.log("Police:", police.address);

    const VehicleMaintenance = await ethers.getContractFactory("VehicleMaintenance");
    const vehicleMaintenance = await VehicleMaintenance.deploy(
        dealer.address,
        client.address,
        mechanic.address,
        insurer.address,
        prefecture.address,
        police.address
    );

    await vehicleMaintenance.waitForDeployment();

    console.log("VehicleMaintenance contract deployed to:", await vehicleMaintenance.getAddress());
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
