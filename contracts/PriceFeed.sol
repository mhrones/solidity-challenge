// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <=0.8.7;


/*

Set up a contract called PriceFeed that can read in price data for ETH
(ETH/USDT, ETH/USDC,  ETH/DAI ect) on chain from any two decentralized 
exchanges of your choice. Every time the function get_prices is called 
it should return the prices for ETH.

*/

import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";

contract PriceFeed {

    //string public name = "Price Feed";

    AggregatorV3Interface internal feeder;

    // Used for testing
    //uint public priceval = 1000;

    constructor() public {
        feeder = AggregatorV3Interface(0x9326BFA02ADD2366b30bacB125260Af641031331);
    }

    function getLatestPrice () external view returns(int) {
        (
            uint80 round_id,
            int price,
            uint started_at,
            uint time_stamp,
            uint80 answer_round
        ) = feeder.latestRoundData();

        return price;
    }
    
}