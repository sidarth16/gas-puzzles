// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.15;

import "hardhat/console.sol";

contract OptimizedArraySum {
    uint256[] array;

    function setArray(uint256[] memory _array) external {
        require(_array.length < 11  , "too long");
        array = _array;
    }

    function getArraySum() external view returns (uint256 sum) {
        for (uint256 i = 0; i < array.length; i++) {
            sum = sum +  array[i];
        }
    }
}

