// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.13;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MockERC20 is ERC20 {

    constructor() ERC20("Fluidly", "FLY") {
        _mint(msg.sender, 100000e18);
    }
}