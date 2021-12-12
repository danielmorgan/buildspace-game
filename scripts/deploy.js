const fs = require('fs');
const { ethers } = require("hardhat");

(async () => {
    const accounts = await ethers.getSigners();
    const contractFactory = await ethers.getContractFactory('MyEpicGame');
    const contract = await contractFactory.deploy(
        ['001', '004', '007'],
        [
            'Bulbasaur',
            'Charmander',
            'Squirtle',
        ],
        [
            'https://i.imgur.com/ReiwDFY.png',
            'https://i.imgur.com/unWkpHk.png',
            'https://i.imgur.com/IogWnKI.png',
        ],
        [110, 100, 90],
        [25, 30, 35],
        '150',
        'Mewtwo',
        'https://i.imgur.com/n9qJRzk.png',
        1000,
        45,
    );
    await contract.deployed();
    console.log('Contract deployed to:', contract.address);

    const dotContract = fs.createWriteStream(`${__dirname}/../.contract`, { flags: 'w' });
    dotContract.write(contract.address);

    // const mint1 = await contract.mintCharacterNFT(0);
    // await mint1.wait();
    //
    // const mint2 = await contract.mintCharacterNFT(1);
    // await mint2.wait();
    //
    // const mint3 = await contract.mintCharacterNFT(2);
    // await mint3.wait();
    //
    // const attack1 = await contract.attackBoss();
    // await attack1.wait();
    //
    // const attack2 = await contract.attackBoss();
    // await attack2.wait();
})();