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
        string name;
        string imageURI;
        uint hp;
        uint maxHp;
        uint attackDamage;
    }

    CharacterAttributes[] defaultCharacters;

    mapping(address => uint256) holders;
    mapping(uint256 => CharacterAttributes) attributes;

    constructor(
        string[] memory characterNames,
        string[] memory characterImageURIs,
        uint[] memory characterHp,
        uint[] memory characterAttackDamage
    ) ERC721("Heroes", "HERO")
    {
        for (uint i = 0; i < characterNames.length; i++) {
            defaultCharacters.push(CharacterAttributes({
                characterIndex: i,
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
                        '{"trait_type":"HP","trait_value":', Strings.toString(_attributes.hp), '},',
                        '{"trait_type":"Max HP","trait_value":', Strings.toString(_attributes.maxHp), '},',
                        '{"trait_type":"Attack DMG","trait_value":', Strings.toString(_attributes.attackDamage), '}',
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
}