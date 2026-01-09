// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract SSPSafeVault is Ownable {
    IERC20 public rewardToken;
    mapping(address => bool) public minters;
    using SafeERC20 for IERC20;

    event Recovered(address token, uint256 amount);

    event Requested(address requester, uint256 amount);

    modifier onlyMinter() {
        require(minters[msg.sender] == true, "onlyMinter: caller is not the minter");
        _;
    }

    constructor(address _rewardToken) Ownable(msg.sender) public{
        rewardToken = IERC20(_rewardToken);
    }
    // only owner can set minter
    function setMinter(address _minter, bool isMinter) external onlyOwner {
        minters[_minter] = isMinter;
    }
    //onlyMinter can request minting
    function mint(uint256 tokenAmount) external onlyMinter {
        require(tokenAmount > 0, "mint: tokenAmount must be greater than 0");
        rewardToken.safeTransfer(msg.sender, tokenAmount);
        emit Requested(msg.sender, tokenAmount);
    }
    // Added to support recovering TRX sent to the contract by mistake
    function recoverTRX(address payable to_, uint256 amount_) external onlyOwner
    {
        require(to_ != address(0), "must not 0");
        require(amount_ > 0, "must gt 0");

        to_.transfer(amount_);
        emit Recovered(address(0), amount_);
    }

    // Added to support recovering LP Rewards from other systems such as BAL to be distributed to holders
    function recoverTRC20(address tokenAddress, uint256 tokenAmount) external onlyOwner {
        IERC20(tokenAddress).safeTransfer(owner(), tokenAmount);
        emit Recovered(tokenAddress, tokenAmount);
    }
}


