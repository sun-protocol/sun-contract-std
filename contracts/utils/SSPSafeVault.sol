// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract SSPSafeVault is Ownable {
    IERC20 public assetToken;
    mapping(address => bool) public minters;
    using SafeERC20 for IERC20;

    event Recovered(address token, uint256 amount);

    event Requested(address requester, uint256 amount);

    modifier onlyMinter() {
        require(minters[msg.sender] == true, "onlyMinter: caller is not the minter");
        _;
    }

    constructor(address initAsset) Ownable(msg.sender){
        assetToken = IERC20(initAsset);
    }

    function setMinter(address minter, bool isMinter) external onlyOwner {
        minters[minter] = isMinter;
    }

    function mint(uint256 tokenAmount) external onlyMinter {
        require(tokenAmount > 0, "mint: tokenAmount must be greater than 0");
        assetToken.safeTransfer(msg.sender, tokenAmount);
        emit Requested(msg.sender, tokenAmount);
    }

    function mintTo(address to, uint256 tokenAmount) external onlyMinter {
        require(tokenAmount > 0, "mintTo: tokenAmount must be greater than 0");
        require(to != address(0), "mintTo: to address must not be zero");
        assetToken.safeTransfer(to, tokenAmount);
        emit Requested(to, tokenAmount);
    }

    function recoverTRX(address payable to, uint256 amount) external onlyOwner
    {
        require(to != address(0), "to address must not be zero");
        require(amount > 0, "amount must be greater than 0");

        (bool success,) = to.call{value:amount}("");
        require(success, 'trx transfer failed');
        emit Recovered(address(0), amount);
    }

    function recoverTRC20(address tokenAddress, uint256 tokenAmount) external onlyOwner {
        IERC20(tokenAddress).safeTransfer(owner(), tokenAmount);
        emit Recovered(tokenAddress, tokenAmount);
    }
}


