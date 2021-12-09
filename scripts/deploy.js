const hre = require('hardhat');

(async () => {
    const accounts = await hre.ethers.getSigners();

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
    console.log('Deployed', contract.address);

    await contract.mintCharacterNFT(2);

    const metadata = await contract.getMetadata(1);
    console.log("Metadata:", JSON.parse(metadata));

    const tokenURI = await contract.tokenURI(1);
    console.log("Token URI:", tokenURI);
})();