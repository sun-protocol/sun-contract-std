// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract SSPSafeVault4 is Ownable {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;
    // HTX mainnet:   0xCA0303E8B9A738121777116DCEA419FE524F271A 
    // HTX nile :  0x37349aEB75a32f8c4c090DAFF376cF975F5d2eBA
    //TODO: deploy mainnet  need token address
    IERC20 public constant rewardToken = IERC20(0xca0303E8b9A738121777116DcEA419Fe524F271A);
    address public sspMinter;

    event Recovered(address token, uint256 amount);

    event SSPRequested(address requester, uint256 amount);


    modifier onlyMinter() {
        require(msg.sender == sspMinter, "onlyMinter: caller is not the minter");
        _;
    }

    constructor() Ownable() public{
    }

    function _init(address _sspMinter) external {
        require(sspMinter == address(0), "only init once");

        sspMinter = _sspMinter;
    }


    function mint(address to_, uint256 _value) external onlyMinter {
        rewardToken.safeTransfer(to_, _value);
        emit SSPRequested(to_, _value);
    }

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


