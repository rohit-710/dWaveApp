// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.4;

import "hardhat/console.sol";

contract WavePortal{

    uint256 totalWaves;

    constructor() 
    {
        console.log("Hello, I am a Wave App that has come to life through Solidity and you've got a friend in me :)");
    }

    function newWave() public
    {
        totalWaves+=1;
        console.log("%s has just added me as a friend and waved at me. ", msg.sender);
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