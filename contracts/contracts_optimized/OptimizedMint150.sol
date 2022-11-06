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

// contract OptimizedAttacker {   // gasUsed : 6728112
//     constructor(address victim) {
//         console.log("Attacker Address : ",msg.sender);
//         unchecked{
//             NotRareToken nft = NotRareToken(victim);

//             uint256 tokenIdCounter = nft.balanceOf( nft.ownerOf(1) ) ;
//                 tokenIdCounter++ ;

//             // for (uint i = 1; i<=10; i++){
//             //     if ( nft.ownerOf(i)==address(0) ){
//             //         baseTokenId = i ;
//             //         break ;
//             //     }
//             // }

//             // for(uint256 i=0; i<150; i++){
//             uint256 lastTokenId = tokenIdCounter + 150 ;
//             while(tokenIdCounter < lastTokenId ){
//                 nft.mint();
//                 nft.transferFrom(address(this), msg.sender, tokenIdCounter);
//                 tokenIdCounter++ ;
//             }
//             selfdestruct(payable(msg.sender));
//         }
//     }
// }

// contract OptimizedAttacker {  // gasUsed : 6714488
//     constructor(address victim) {
//         console.log("Attacker Address : ",msg.sender);
//         unchecked{
//             NotRareToken nft = NotRareToken(victim);

//             uint256 tokenIdCounter = nft.balanceOf( nft.ownerOf(1) ) ;
//                 tokenIdCounter++ ;

//             uint256 lastTokenId = tokenIdCounter + 150 ;
//             while(tokenIdCounter < lastTokenId ){

//                 // victim.call{gas: 1000000, value: 1 ether}(abi.encodeWithSignature("Test(uint, uint)", 12, 35));
//                 // bytes4 payload = NotRareToken(victim).mint.selector;// "0x1249c58b" ; //abi.encodeWithSignature("mint()");
//                 // victim.call(abi.encode(payload));

//                 victim.call(hex"1249c58b");   // check hex : https://docs.soliditylang.org/en/v0.8.7/types.html#hexadecimal-literals
//                 nft.transferFrom(address(this), msg.sender, tokenIdCounter);
//                 tokenIdCounter++ ;
//             }
//             // tokenIdCounter = 0;
//             selfdestruct(payable(msg.sender));
//         }
//     }
// }

// contract OptimizedAttacker {  // gasUsed : 6707691
//     constructor(address victim) {
//         unchecked{
//             NotRareToken nft = NotRareToken(victim);
//             uint256 tokenIdCounter = nft.balanceOf( nft.ownerOf(1) ) + 1 ;
//             uint256 lastTokenId = tokenIdCounter + 150 ;

//             while(lastTokenId - tokenIdCounter > 0 ){

//                 // victim.call{gas: 1000000, value: 1 ether}(abi.encodeWithSignature("Test(uint, uint)", 12, 35));
//                 // bytes4 payload = NotRareToken(victim).mint.selector;// "0x1249c58b" ; //abi.encodeWithSignature("mint()");
//                 // victim.call(abi.encode(payload));

//                 victim.call(hex"1249c58b");   // check hex : https://docs.soliditylang.org/en/v0.8.7/types.html#hexadecimal-literals
//                 nft.transferFrom(address(this), msg.sender, tokenIdCounter++);
//             }
//             selfdestruct(payable(msg.sender));
//         }
//     }
// }

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


// contract OptimizedAttackerFactory {
//     constructor(address victim, uint256 tokenId) {
//         NotRareToken nft = NotRareToken(victim);

//         nft.mint();
//         nft.transferFrom(address(this), 0x70997970C51812dc3A010C7d01b50e0d17dc79C8, tokenId );
//         selfdestruct(payable(0x70997970C51812dc3A010C7d01b50e0d17dc79C8));
//     }
// }

// contract OptimizedAttacker {
//     constructor(address victim) {
//         console.log("Attacker Address : ",msg.sender);
//         NotRareToken nft = NotRareToken(victim);
//         uint256 tokenIdCounter = nft.balanceOf( nft.ownerOf(1) ) + 1 ;
//         for(uint i=0; i<150; i++){
//             new OptimizedAttackerFactory(victim, tokenIdCounter+i);
//         }
//         selfdestruct(payable(msg.sender));
//     }
// }


// function mint150(address victim) external  returns(bytes memory) {
//         console.log("Attacker Address : ",msg.sender);
//         unchecked{
//             // NotRareToken nft = NotRareToken(victim);
//             bytes memory payload = abi.encodeWithSignature("mint()");
//             victim.call(payload);
//             return payload;

//             }
// }