// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.15;

contract OptimizedDistribute {
    address[4] public contributors;
    uint256 immutable public createTime;
    address immutable contributors0;
    address immutable contributors1;
    address immutable contributors2;
    address immutable contributors3;

    constructor(address[4] memory _contributors) payable {
        contributors = _contributors;
        contributors0 = _contributors[0];
        contributors1 = _contributors[1];
        contributors2 = _contributors[2];
        contributors3 = _contributors[3];
        createTime = block.timestamp+ 1 weeks;
    }

    function distribute() external {
        require(block.timestamp > createTime ,   "cannot distribute yet"  );

        uint256 amount = address(this).balance  >> 2;
        payable(contributors0).send(amount);
        payable(contributors1).send(amount);
        payable(contributors2).send(amount);
        selfdestruct(payable(contributors3));
    }
}
