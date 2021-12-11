const fs = require('fs');
const { ethers } = require("hardhat");

(async () => {
    const accounts = await ethers.getSigners();
    const contractFactory = await ethers.getContractFactory('MyEpicGame');
    const contract = await contractFactory.deploy(
        ['Foo', 'Bar', 'Baz'],
        [
            'https://via.placeholder.com/512/FF0000/FFFFFF/?text=FOO',
            'https://via.placeholder.com/512/00FF00/FFFFFF/?text=BAR',
            'https://via.placeholder.com/512/0000FF/FFFFFF/?text=BAZ',
        ],
        [100, 110, 90],
        [30, 25, 35],
        'Boss',
        'https://via.placeholder.com/512/000000/FFFFFF/?text=BOSS',
        1000,
        30,
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