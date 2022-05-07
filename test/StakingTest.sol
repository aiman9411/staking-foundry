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
    uint256 public constant AMOUNT = 1e18; 

    function setUp() public {
        token = new MockERC20();
        rewardToken = new MockRewardToken();
        stakeContract = new StakeContract(address(rewardToken), address(token));
    }

    function testExample() public {
        assertTrue(true);
    }

    function testStakingToken() public {
        token.approve(address(stakeContract), AMOUNT);
        bool success = stakeContract.stake(AMOUNT);
        assertTrue(success);
    }
}
