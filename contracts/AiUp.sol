// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

// Uncomment this line to use console.log
import "hardhat/console.sol";

contract AiUp is ERC721Enumerable, Ownable {
    string private constant _NAME = "AI UPs";
    string private constant _SYMBOL = "UP";
    address payable _OWNER; 
   

    // Optional mapping for token URIs
    mapping(uint256 => string) private _tokenURIs;

    event Mined(address indexed minerAddress, uint tokenId, bytes tokenURI);
    address private _aRandomSecretKey; 
    constructor(address _secret) ERC721(_NAME, _SYMBOL) {
        _aRandomSecretKey = _secret; 
        _OWNER = payable(msg.sender); 
    }

    function setTokenURI(
        uint256 tokenId,
        string memory _tokenURI
    ) onlyOwner external virtual {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI set of nonexistent token"
        );
        bytes memory tempString = bytes(_tokenURIs[tokenId]); 
        // Require NFT TokenURI to be empty
        // To avoid reposting Metadata 
        require(tempString.length < 1, "NFT Metadata already set!"); 
        if(tempString.length == 0) {
             _tokenURIs[tokenId] = _tokenURI;
        } 
    }

    function _getTokenUri(uint256 tokenId) internal view returns (string memory) {
        return _tokenURIs[tokenId]; 
    }

    function mintToken() public payable returns (uint256) {
        require(totalSupply() < 100, "Maximum amount of images minted!");
        require(msg.value == 0.1 ether, 'Mint Price Wrong'); 
        uint256 tokenId = totalSupply();
        _OWNER.transfer(msg.value); 
        _mint(msg.sender, tokenId);
        return totalSupply();
    } 

    function tokenURI(uint256 _tokenId) public view override returns (string memory) {
        return _getTokenUri(_tokenId); 
    }
}

