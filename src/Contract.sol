// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

/**
@title Staking App
@author Aiman Nazmi
@notice This is a smart contract - a program that can be deployed into Ethereum blockchain
*/

// @notice ERC20 Interface
interface IERC20 {
    function totalSupply() external view returns (uint);

    function balanceOf(address account) external view returns (uint);

    function transfer(address recipient, uint amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);
}

contract Staking {

    // @notice IERC20 for reward token & staking token
    IERC20 public rewardsToken;
    IERC20 public stakingToken;

    // @notice Reward rate to determine reward amount
    uint256 public rewardRate = 1;
    // @notice Last time user updates amount
    uint256 public lastUpdateTime;
    // @notice Reward amount per token
    uint256 public rewardPerTokenStored;
    // @notice Total token supply in this contract
    uint256 private _totalSupply;

    // @notice Mapping user to paid reward
    mapping(address => uint256) public userRewardPaid;
    // @notice Mapping user to reward
    mapping(address => uint256) rewards;
    // @notice Mapping user to balance
    mapping(address => uint256) balances;    

    // @notice Initialize constructor
    constructor(address _rewardsToken, address _stakingToken) {
        rewardsToken = IERC20(_rewardsToken);
        stakingToken = IERC20(_stakingToken);
    }

    // @notice Function to view reward per token based on staked amount
    function rewardPerToken() public view returns (uint256) {
        if (_totalSupply == 0) {
            return rewardPerTokenStored;
        }
        return
            rewardPerTokenStored + (((block.timestamp - lastUpdateTime) * rewardRate * 1e18) / _totalSupply);
    }

    // @notice Function to view earned reward minus paid reward
    function earned(address account) public view returns (uint256) {
        return (balances[account] * rewardPerToken() - userRewardPaid[account]) + rewards[account];
    }

    // @notice Modifier to update rewards
    modifier updateRewards(address account) {
        lastUpdateTime = block.timestamp;
        rewards[account] = earned(account);
        _;
    }

    // @notice Function to stake token
    // @param _amount Amount of token to stake
    function stake(uint256 _amount) external updateRewards(msg.sender) {
        _totalSupply += _amount;
        balances[msg.sender] += _amount;
        stakingToken.transferFrom(msg.sender, address(this), _amount);
    }

    // @notice Function to withdraw token
    // @param _amount Amount of staken token to withdraw
    function withdraw(uint256 _amount) external updateRewards(msg.sender) {
        _totalSupply -= _amount;
        balances[msg.sender] -= _amount;
        stakingToken.transfer(msg.sender, _amount);
    }

    // @notice Function to get rewards
    function getRewards() external updateRewards(msg.sender) {
        uint reward = rewards[msg.sender];
        rewards[msg.sender] = 0;
        userRewardPaid[msg.sender] += reward;
        rewardsToken.transfer(msg.sender, reward);
    }

}
