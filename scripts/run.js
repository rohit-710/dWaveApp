const main = async () => {
    
    //n order to deploy something to the blockchain, we need to have a wallet address! Hardhat does this 
    //for us magically in the background, but here I grabbed the wallet address of contract owner and I also 
    //grabbed a random wallet address and called it randomPerson.
    //Syntax: const [owner, randomPerson] = await hre.ethers.getSigners();


    //This will actually compile our contract and generate the necessary files we need to work 
    //with our contract under the artifacts directory. 
    const waveContractFactory = await hre.ethers.getContractFactory("WavePortal");

    //What's happening here is Hardhat will create a local Ethereum network for us, but just for this contract. 
    //Then, after the script completes it'll destroy that local network. So, every time you run the contract, it'll 
    //be a fresh blockchain. What's the point? It's kinda like refreshing your local server every time so you 
    //always start from a clean slate which makes it easy to debug errors.
    const waveContract = await waveContractFactory.deploy(
      {
        value: hre.ethers.utils.parseEther("0.1"),
      }
    );

    //We'll wait until our contract is officially deployed to our local blockchain! Our constructor runs when we actually deploy.
    await waveContract.deployed();

    //Finally, once it's deployed waveContract.address  will basically give us the address of the deployed contract. This 
    //address is how we can actually find our contract on the blockchain. There are millions of contracts on the actual 
    //blockchain. So, this address gives us easy access to the contract we're interested in working with! This will be more 
    //important a bit later once we deploy to a real Ethereum network.
    console.log("Contract deployed to:", waveContract.address);
    //console.log("Contract deployed by:", owner.address);

    //Get contract Balance
    let contractBalance = await hre.ethers.provider.getBalance(
      waveContract.address
    );
    console.log(
      "Contract balance:",
      hre.ethers.utils.formatEther(contractBalance)
    );

    //First I call the function to grab the # of total waves. Then, I do the wave. Finally, I grab the waveCount 
    //one more time to see if it changed.

    let waveCount;
    waveCount = await waveContract.showTotalWaves();
    
    const waveTxn = await waveContract.newWave("This is wave #1");
    await waveTxn.wait(); //waits for contract to be mined
    
    const waveTxn2 = await waveContract.newWave("This is wave #2");
    await waveTxn2.wait()
    const [_, randomPerson] = await hre.ethers.getSigners();

    //Get Contract Balance
    contractBalance = await hre.ethers.provider.getBalance(waveContract.address);
    console.log(
      "Contract balance:",hre.ethers.utils.formatEther(contractBalance)
      );

    /*
    
    //The below code is to allow someone to send us a wave, and make our website interactive for users. 
    waveTxn = await waveContract.connect(randomPerson).newWave("Another message!");
    await waveTxn.wait(); // Wait for the transaction to be mined

    */

    let allWaves = await waveContract.getAllWaves();
    console.log(allWaves);
  };
  
  const runMain = async () => {
    try {
      await main();
      process.exit(0); // exit Node process without error
    } catch (error) {
      console.log(error);
      process.exit(1); // exit Node process while indicating 'Uncaught Fatal Exception' error
    }
    
  };
  
  runMain();