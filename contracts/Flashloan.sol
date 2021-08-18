// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <=0.8.7;


/*

Set up a contract called Flashloan that can call 
the PriceFeed contract and store the prices received 
from get_prices into a global variables (this 
global variable is not used, just to test if you are
able to have contracts interact with each other). 
The Flashloan contract should also have a function 
called start_flashloan, when this function is 
called, it should attempt to borrow 100 Dai, perform 
no trades, and simply return the Dai at the end + pay 
the fee. Perform the flashloan using Aave.

*/

import "./PriceFeed.sol";
import "@aave/protocol-v2/contracts/interfaces/ILendingPoolAddressesProvider.sol";
import "@aave/protocol-v2/contracts/interfaces/ILendingPool.sol";
import "@aave/protocol-v2/contracts/flashloan/base/FlashLoanReceiverBase.sol";
import "@aave/protocol-v2/contracts/dependencies/openzeppelin/contracts/IERC20.sol";

contract Flashloan is FlashLoanReceiverBase{


    address PriceFeedAddress;

    function set_address(address _PriceFeedAddress) external {
        PriceFeedAddress = _PriceFeedAddress;
    }

    function call_get_prices() external view returns(int) {
        PriceFeed pricefeed = PriceFeed(PriceFeedAddress);
        return pricefeed.getLatestPrice();
    }


    constructor(ILendingPoolAddressesProvider _addressProvider) FlashLoanReceiverBase(_addressProvider) public {}

    function executeOperation(
        address[] calldata assets,
        uint256[] calldata amounts,
        uint256[] calldata premiums,
        address initiator,
        bytes calldata params
    ) external override returns (bool) {

        for (uint i = 0; i < assets.length; i++) {
            uint amountOwing = amounts[i].add(premiums[i]);
            IERC20(assets[i]).approve(address(LENDING_POOL), amountOwing);
        }

        return true;
    }

    function start_flashloan() external {
        
        address recipient = address(this);

        address[] memory assets = new address[](1);
        assets[0] = address(0xFf795577d9AC8bD7D90Ee22b6C1703490b6512FD); // DAI contract address

        uint256[] memory amounts = new uint256[](1);
        amounts[0] = 100;

        uint[] memory modes = new uint256[](1);
        modes[0] = 1;

        address onBehalfOf = recipient;

        bytes memory params = "";
        uint16 referralCode = 0;

        LENDING_POOL.flashLoan(recipient, assets, amounts, modes, onBehalfOf, params, referralCode);

    }

    

}