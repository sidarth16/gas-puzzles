//SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.15;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "hardhat/console.sol";

// You may not modify this contract or the openzeppelin contracts
contract NotRareToken is ERC721 {
    mapping(address => bool) private alreadyMinted;

    uint256 private totalSupply;

    constructor() ERC721("NotRareToken", "NRT") {}

    function mint() external {
        totalSupply++;
        _safeMint(msg.sender, totalSupply);
        alreadyMinted[msg.sender] = true;
    }
}


contract OptimizedAttacker {  // gasUsed : 6707691
    constructor(address victim) {
        unchecked{
            NotRareToken nft = NotRareToken(victim);

            address user1;
            (, bytes memory data) = victim.staticcall(hex"6352211e0000000000000000000000000000000000000000000000000000000000000001");
            assembly {
                user1 := mload(add(data, 32))
            } 

            // uint256 tokenIdCounter = nft.balanceOf( 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266 ) + 1 ;
            uint256 tokenIdCounter = nft.balanceOf( user1 ) + 1 ;
            uint256 lastTokenId = tokenIdCounter + 150 ;

            delete data;
            delete user1;

            while(lastTokenId - tokenIdCounter > 0 ){
                victim.call(hex"1249c58b");   // check hex : https://docs.soliditylang.org/en/v0.8.7/types.html#hexadecimal-literals
                nft.transferFrom(address(this), msg.sender, tokenIdCounter++);
            }
            selfdestruct(payable(msg.sender));
        }
    }
}

