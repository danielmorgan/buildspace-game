const hre = require('hardhat');

(async () => {
    const contractFactory = await hre.ethers.getContractFactory('MyEpicGame');
    const contract = await contractFactory.deploy(
        ['Foo', 'Bar', 'Baz'],
        [
            'https://via.placeholder.com/512/FF0000/FFFFFF/?text=FOO',
            'https://via.placeholder.com/512/00FF00/FFFFFF/?text=BAR',
            'https://via.placeholder.com/512/0000FF/FFFFFF/?text=BAZ',
        ],
        [100, 110, 90],
        [7, 6, 8]
    );
    await contract.deployed();
    console.log('Contract deployed to:', contract.address);

    const mint1 = await contract.mintCharacterNFT(0);
    await mint1.wait();
    console.log('Minted NFT #1 (Foo)');

    const mint2 = await contract.mintCharacterNFT(1);
    await mint2.wait();
    console.log('Minted NFT #2 (Bar)');

    const mint3 = await contract.mintCharacterNFT(2);
    await mint3.wait();
    console.log('Minted NFT #3 (Baz)');

    const mint4 = await contract.mintCharacterNFT(1);
    await mint4.wait();
    console.log('Minted NFT #4 (Bar)');
})();