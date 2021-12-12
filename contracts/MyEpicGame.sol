// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "base64-sol/base64.sol";

contract MyEpicGame is ERC721 {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIds;

    struct CharacterAttributes {
        uint characterIndex;
        string dexNumber;
        string name;
        string imageURI;
        uint hp;
        uint maxHp;
        uint attackDamage;
    }

    CharacterAttributes[] defaultCharacters;

    struct BigBoss {
        string dexNumber;
        string name;
        string imageURI;
        uint hp;
        uint maxHp;
        uint attackDamage;
    }

    BigBoss public bigBoss;

    mapping(address => uint256) public holders;
    mapping(uint256 => CharacterAttributes) public attributes;

    event CharacterNFTMinted(address sender, uint256 tokenId, uint256 characterIndex);
    event AttackCompleted(uint newBossHp, uint newPlayerHp);

    constructor(
        string[] memory characterDexNumbers,
        string[] memory characterNames,
        string[] memory characterImageURIs,
        uint[] memory characterHp,
        uint[] memory characterAttackDamage,
        string memory bossDexNumber,
        string memory bossName,
        string memory bossImageURI,
        uint bossHp,
        uint bossAttackDamage
    ) ERC721("Buildspace Pokemon", "PKMN")
    {
        bigBoss = BigBoss({
            dexNumber: bossDexNumber,
            name: bossName,
            imageURI: bossImageURI,
            hp: bossHp,
            maxHp: bossHp,
            attackDamage: bossAttackDamage
        });

        console.log("[Boss] HP: %s - %s",
            bigBoss.hp,
            bigBoss.imageURI
        );

        for (uint i = 0; i < characterNames.length; i++) {
            defaultCharacters.push(CharacterAttributes({
                characterIndex: i,
                dexNumber: characterDexNumbers[i],
                name: characterNames[i],
                imageURI: characterImageURIs[i],
                hp: characterHp[i],
                maxHp: characterHp[i],
                attackDamage: characterAttackDamage[i]
            }));

            console.log("[%s] HP: %s - %s",
                defaultCharacters[i].name,
                defaultCharacters[i].hp,
                defaultCharacters[i].imageURI
            );
        }
    }

    function mintCharacterNFT(uint _characterIndex) external {
        _tokenIds.increment();
        uint256 newId = _tokenIds.current();

        _safeMint(msg.sender, newId);

        CharacterAttributes memory newAttributes = defaultCharacters[_characterIndex];
        attributes[newId] = newAttributes;

        holders[msg.sender] = newId;

        emit CharacterNFTMinted(msg.sender, newId, _characterIndex);
    }

    function getMetadata(uint256 _tokenId) public view returns (string memory) {
        CharacterAttributes memory _attributes = attributes[_tokenId];

        return string(
            abi.encodePacked(
                '{',
                    '"name":"', _attributes.name, ' - #', Strings.toString(_tokenId), '",',
                    '"description":"Buildspace Create your own mini turn-based NFT browser game project",',
                    '"image":"', _attributes.imageURI, '",',
                    '"attributes":[',
                        '{"trait_type":"Dex Number","display_type":"number","value":', _attributes.dexNumber, '},',
                        '{"trait_type":"HP","value":', Strings.toString(_attributes.hp), ',"max_value":', Strings.toString(_attributes.maxHp), '},',
                        '{"trait_type":"Attack DMG","value":', Strings.toString(_attributes.attackDamage), '}',
                    ']',
                '}'
            )
        );
    }

    function tokenURI(uint256 _tokenId) public view override returns (string memory) {
        string memory encodedMetadata = Base64.encode(bytes(getMetadata(_tokenId)));
        bytes memory dataUrl = abi.encodePacked('data:application/json;base64,', encodedMetadata);
        return string(dataUrl);
    }

    function attackBoss() public {
        uint256 tokenId = holders[msg.sender];
        CharacterAttributes storage player = attributes[tokenId];

        console.log("\nPlayer w/ character %s about to attack. Has %s HP and %s AD", player.name, player.hp, player.attackDamage);
        console.log("Boss %s has %s HP and %s AD", bigBoss.name, bigBoss.hp, bigBoss.attackDamage);

        require(player.hp > 0, "Error: Character must have HP to attack.");
        require(bigBoss.hp > 0, "Error: Boss must have HP to be attacked.");

        if (bigBoss.hp < player.attackDamage) {
            bigBoss.hp = 0;
        } else {
            bigBoss.hp -= player.attackDamage;
        }

        if (player.hp < bigBoss.attackDamage) {
            player.hp = 0;
        } else {
            player.hp -= bigBoss.attackDamage;
        }

        console.log("Player attacked boss. New boss hp: %s", bigBoss.hp);
        console.log("Boss attacked player. New player hp: %s\n", player.hp);

        emit AttackCompleted(bigBoss.hp, player.hp);
    }

    function checkIfUserHasNFT() public view returns (CharacterAttributes memory) {
        uint256 tokenId = holders[msg.sender];

        if (tokenId > 0) {
            return attributes[tokenId];
        }

        CharacterAttributes memory emptyStruct;
        return emptyStruct;
    }

    function getAllDefaultCharacters() public view returns (CharacterAttributes[] memory) {
        return defaultCharacters;
    }

    function getBigBoss() public view returns (BigBoss memory) {
        return bigBoss;
    }
}