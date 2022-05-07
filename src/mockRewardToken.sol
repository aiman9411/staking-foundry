// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.13;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MockRewardToken is ERC20 {

    constructor() ERC20("Reward Token", "rTKN") {
        _mint(msg.sender, 100000e18);
    }
}