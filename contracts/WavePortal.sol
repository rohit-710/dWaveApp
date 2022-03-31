// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.4;

import "hardhat/console.sol";

contract WavePortal{

    constructor() payable {
        console.log("We have been constructed!");

        seed = (block.timestamp + block.difficulty) % 100; //Setting the initial seed
    }
    uint256 totalWaves;
    uint256 private seed; //To generate a random number
    
    //Creating a new event
    //An event is an inheritable member of the contract, which stores the arguments passed in the 
    //transaction logs when emitted. Generally, events are used to inform the calling application about the current state of the contract, with the help of the logging facility of EVM.
    event showWave(address indexed from, uint256 timestamp, string message);

    
    //I created a struct here named Wave which stores some of the information of every wave waved.
    //It stores address of the waver, the message put in by the waver and the time stamp of when the wave was waved. 
    //A struct is basically a custom datatype where we can customize what we want to hold inside it.
    
    struct Wave {
        address waver; // The address of the user who waved.
        string message; // The message the user sent.
        uint256 timestamp; // The timestamp when the user waved.
    }

     
    

    //We declare a variable waves of the datatype "Wave" that lets us store an array of structs.
    //This is what lets us hold all the waves anyone ever sends to us!
    Wave[] waves;
    /*constructor() 
    {
        console.log("I am the smart contract and I have just come to life. Let's go!");
    }*/

    /*
     * This is an address => uint mapping, meaning I can associate an address with a number!
     * In this case, I'll be storing the address with the last time the user waved at us.
     */
    mapping(address => uint256) public lastWavedAt;

    function newWave(string memory _message) public
    {
        /*
         * We need to make sure the current timestamp is at least 30 seconds more than the last timestamp we stored
         */
        require(lastWavedAt[msg.sender] + 30 seconds < block.timestamp, "Must wait 30 seconds before waving again.");

        /*
         * Update the current timestamp we have for the user
         */
        lastWavedAt[msg.sender] = block.timestamp;

        totalWaves+=1;
        console.log("%s has just added me as a friend and waved at me. ", msg.sender, _message);

        //This is where we store the message and the details of the wave to the array.
        waves.push(Wave(msg.sender, _message, block.timestamp));

        //Generate a new seed 
        seed = (block.difficulty + block.timestamp + seed) % 100;

        console.log("Random # generated: %d", seed);

        //Now we give the user a 50% chance to win
         if (seed <= 50) {
            console.log("%s won!", msg.sender);

            /*
             * The same code we had before to send the prize.
             */
            uint256 prizeAmount = 0.0001 ether;
            require(
                prizeAmount <= address(this).balance,
                "Trying to withdraw more money than the contract has."
            );
            (bool success, ) = (msg.sender).call{value: prizeAmount}("");
            require(success, "Failed to withdraw money from contract.");
        }

        //Now, we emit the event details
        //In order to make events stand out with regards to regular function calls, emit EventName() 
        //as opposed to just EventName() should now be used to "call" events.

        emit showWave(msg.sender, block.timestamp, _message);

        /*

        //To start we're just going to give everyone who waves at us 0.0001 ETH. Which is $0.31. 
        //And this is all happening on testnet, so, it's fake $!

        uint256 prizeAmount = 0.0001 ether;

        //require which basically checks to see that some condition is true.
        //If it's not true, it will quit the function and cancel the transaction.

        //address(this).balance is the balance of the contract itself.
        require(
            prizeAmount <= address(this).balance,
            "Trying to withdraw more money than the contract has."
            );
        (bool success, ) = (msg.sender).call{value: prizeAmount}("");
        require(success, "Failed to withdraw money from contract.");

        */

    }

    //We create a function getAllWaves which will return the struct array, waves, to us.
    //This will make it easy to retrieve the waves from our website!
    
    function getAllWaves() public view returns (Wave[] memory) {
        return waves;
    }


    // msg.sender, this is the wallet address of the person who called the function. It's like built-in authentication. 
    //We know exactly who called the function because in order to even call a smart contract function, 
    //you need to be connected with a valid wallet!

    //In the future, we can write functions that only certain wallet addresses can hit. For example, 
    //we can change this function so that only our address is allowed to send a wave. Or, maybe have it where only 
    //your friends can wave at you!

    function showTotalWaves() public view returns (uint256)
    {
        console.log("We have a total number of %d friends and waves Here's to a new beginning. ", totalWaves);
        return totalWaves;
    }
}