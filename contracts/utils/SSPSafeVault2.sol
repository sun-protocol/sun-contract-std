// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;

import "./base/IERC20.sol";
import "./base/SafeERC20.sol";
import "./base/Ownable.sol";


contract SSPSafeVault2 is Ownable {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;
    // mainnet: TSSMHYeV2uE9qYH95DqyoCuNCzEL1NvU3S  0xb4A428ab7092c2f1395f376cE297033B3bB446C1
    // nile : TDqjTkZ63yHB19w2n7vPm2qAkLHwn9fKKk  0x2A769a33b6ed01a074e4a45bfFa0778A27949BEc
    //TODO: deploy mainnet
    IERC20 public constant sspToken = IERC20(0xb4A428ab7092c2f1395f376cE297033B3bB446C1);
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
        sspToken.safeTransfer(to_, _value);
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


