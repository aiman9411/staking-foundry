// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/StakeContract.sol";
import "../src/mockERC20.sol";
import "../src/mockRewardToken.sol";

contract ContractTest is Test {
    StakeContract public stakeContract;
    ERC20 public token;
    ERC20 public rewardToken;
    // uint256 public constant AMOUNT = 1e18; 

    function setUp() public {
        token = new MockERC20();
        rewardToken = new MockRewardToken();
        stakeContract = new StakeContract(address(rewardToken), address(token));
    }

    function testStakingToken(uint256 amount) public {
        token.approve(address(stakeContract), amount);
        bool success = stakeContract.stake(amount);
        assertTrue(success);
    }

}