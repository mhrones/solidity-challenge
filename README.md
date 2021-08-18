# AP Capital Solidity Challenge

This project was to assess Solidity programming skills ahead of an interview with APCapital. The challenge was broke into three main tasks, with an addition "bonus" task that combined the contracts of tasks two and three. Task one simply involved pulling ETH price data directly from the blockchain. Task two was broken into two, unconnected parts: the first was to implement a method to be able to call the the price-getter function from the first task, while also writing the contract to be able to perform a flashloan using Aave. The third task was to implement a token swap using the Uniswap protocol, while the fourth task was to write a contract that would perform a flashloan, convert the token to ETH, then convert back before completing the flashloan. Tasks one was fully completed and task two was mostly completed, while I did not have enough time to learn the required information to complete task three. 

The contracts were built using the truffle development framework, launched on the Kovan test network via https://infura.io/. Address used for contract creation is <code>0xf96776E65b68d8B6a48cA03B73dA9A918abB0913</code>

To launch the contracts, the following command was used: <code>truffle migrate --reset --network kovan</code>

# TASK ONE

Contract is live at <code>0x4dbCfb217fB2C2D7C764d6ad070AEC78aC20Df26</code>

> Set up a contract called PriceFeed that can read in price data for ETH
(ETH/USDT, ETH/USDC,  ETH/DAI ect) on chain from any two decentralized 
exchanges of your choice. Every time the function get_prices is called 
it should return the prices for ETH.

Initial attempts to complete this task was looking through the docs of various DEX platforms, specifically IDEX and Uniswap. The correct method would have been to access the prices for ETH directly from the DEX pools, however difficulty was met when trying figure out how to access those pools. Instead, Chainlink's PriceAggregator was used to access the price of ETH on the Kovan testnet.

To call the getLatestPrices() function, the following process is used. 

1. Load truffle console on Kovan network with console command <code>truffle console --network kovan</code>

2. Assign the deployed contract to a variable <code>feeder = await PriceFeed.deployed()</code>

3. Call <code>feeder.getLatestPrice()</code>

4. Price data from Kovan Chainlink Aggregator is returned

An array is returned where index 1 contains the price data. The price data is not the same as what would be found on CoinMarketCap or other mainnet exchange sites, as it is accessing information from the testnet rather than the mainnet which would have the real-world price data. 

# TASK TWO

Contract is live at <code>0x6D69e1f73d52975aDD33Ae0695E56e166CB8c1d2</code>

>A) Set up a contract called Flashloan that can call 
the PriceFeed contract and store the prices received 
from get_prices into a global variables (this 
global variable is not used, just to test if you are
able to have contracts interact with each other).

The Flashloan contract was loaded into console using <code>loaner = await Flashloan.deployed()</code> and has two functions within it that allows it to interact with the PriceFeed contract, <code>set_address()</code> and <code>call_get_prices()</code>. Once the PriceFeed contract was launched, the address for the contract was aquired in the truffle console using <code>feeder.address</code> and passed as an argument to <code>loaner.set_address()</code>. After that, it became possible to simply call <code>loaner.call_get_prices()</code> which returns the same data as <code>feeder.getLatestPrice()</code>. 

>B) The Flashloan contract should also have a function 
called start_flashloan, when this function is 
called, it should attempt to borrow 100 Dai, perform 
no trades, and simply return the Dai at the end + pay 
the fee. Perform the flashloan using Aave.

The latter half of the contract implements the Flashloan functionality. However, the flashloan does not sucessfully complete for reasons unknown. The transaction was constructed and broadcasted, yet did not complete giving <code>error (status 0)</code>. The rest of the information in this section will be how the flashloan was implemented with specifics, problems that were ran into then solved, and potential reasons identified that could be causing this issue.

A major problem that assumingly was fixed was which address for the DAI contract to use. At first the mainnet DAI address was used before the quick realization that this was incorrect. Then, "DAI Stablecoin" at contract address <code>0xe680fa3cf20caab259ab3e2d55a29c942ad72d01</code> was used, but again realized that this was incorrect as well. Finally, documentation was found on what testnet DAI is used on Aave, DAI was aquired from the Aave testnet faucet, and DAI contract address <code>0xFf795577d9AC8bD7D90Ee22b6C1703490b6512FD</code> was used. This seems to be the correct address to use for the Flashloan, however it is possible there is some other contract that should be used.

Problems arose when trying to call the Flashloan without any DAI inside the contract. Getting Kovan DAI from online faucets and transfering to the contract appeared to have solved this issue. 

In the migration file, the Lending Pool Address was passed as an argument into the contract (<code>0x6D69e1f73d52975aDD33Ae0695E56e166CB8c1d2</code>). This address exists on the mainnet as well, marked on etherscan as "Aave V2: Lending Pool." Tthis address was used as documentation was not found regarding a specific Aave V2: Lending Pool Address on the Kovan Network.

Inspecting the [failed transaction on etherscan](https://kovan.etherscan.io/tx/0x5d070a9f7b6694fa19b511d355cbaf7bed942ff9d04c550013fb745214fd3921) provided some additional clues to where the error might have arose. Specifically, hitting the "Click to see more" drop down menu shows how much gas was used by the transaction. According to the site, only 0.38% of the gas was used before the transaction failed, implying that the transaction failed very early on in the process. This information could be irrelevant, maybe the transaction failing at the start means that there is an error later on that prevents the whole thing from going through. Alternatively, it could imply that the issue lies specifically with in the start of the flash loan, potentially something with the lending pool address. 











