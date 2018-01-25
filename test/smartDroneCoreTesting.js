var SmartDroneCore = artifacts.require("./SmartDroneCore.sol");
var SaleClockAuction = artifacts.require("./SaleClockAuction.sol");
var AIScience = artifacts.require("./AIScience.sol")
var WarResolution = artifacts.require("./WarResolution.sol")
var Matchmaker = artifacts.require("./MatchMaker.sol")
var Manufacturing = artifacts.require("./Manufacturing")

contract('SmartDroneCore', function(accounts) {
  var coreInstance;
  var warResolutionInstance;
  var manufacturingInstance;

  //Setup the other managers
  it("...should set the EthManager.", function() {
    return SmartDroneCore.deployed().then(function(instance) {
      coreInstance = instance;
      return coreInstance.setEthManager(accounts[0], {from: accounts[0]});
    }).then(function() {
      return coreInstance.ethManagerAddress.call();
    }).then(function(ethAddress) {
      assert.equal(ethAddress, accounts[0], "The account was not set.");
    });
  });

  it("...should set the ConManager.", function() {
      return coreInstance.setConManager(accounts[0], {from: accounts[0]}).then(function() {
      return coreInstance.conManagerAddress.call();
    }).then(function(ethAddress) {
      assert.equal(ethAddress, accounts[0], "The account was not set.");
    });
  });

  it("...should set the TokManager.", function() {
      return coreInstance.setTokManager(accounts[0], {from: accounts[0]}).then(function() {
      return coreInstance.tokManagerAddress.call();
    }).then(function(ethAddress) {
      assert.equal(ethAddress, accounts[0], "The account was not set.");
    });
  });

  it("...should set the Auction contract.", function() {
       return SaleClockAuction.deployed().then(function(insta){
        saleInst = insta;
         coreInstance.setSaleAuctionAddress(saleInst.address,{from: accounts[0]}).then(function(){
          return coreInstance.saleAuction.call().then(function(contra){
            assert.equal(contra,saleInst.address, "Matchmaking contract not set");
          });  
        });
      });
    });
 
    //Setup the other contracts

  it("...should set the Matchmaking contract.", function() {
      return  Matchmaker.new([coreInstance.address,9000],{from: accounts[0]}).then(function(retInst){
        matchMakerInstance = retInst;
        coreInstance.setMatchmakerAddress(matchMakerInstance.address,{from: accounts[0]}).then(function(){
         return coreInstance.matchMaker.call().then(function(contra){
           assert.equal(contra,matchMakerInstance.address, "Matchmaking contract not set");
         });  
       });

      });
      
    });
  
    it("...should set the War Resolution contract.", function() {
      return WarResolution.deployed().then(function(warinst){
        warResolutionInstance = warinst;
        coreInstance.setWarAddress(warResolutionInstance.address,{from: accounts[0]}).then(function(){
         return coreInstance.warResolution.call().then(function(contra){
           assert.equal(contra,warResolutionInstance.address, "War resolution contract not set");
         });  
       });
     });
   });

   it("...should set the Manufacturing contract.", function() {
    return Manufacturing.new([coreInstance.address],{from: accounts[0]}).then(function(manInst){
      manufacturingInstance = manInst;
      coreInstance.setManufacturingAddress(manufacturingInstance.address,{from: accounts[0]}).then(function(){
       return coreInstance.manufacturingAddress.call().then(function(contra){
         assert.equal(contra,manufacturingInstance.address, "Manufacturing contract not set");
       });  
     });
    }); 
   });

  //Test unpausing and pausing
  it("...should un-pause the contract.", function() {
    return coreInstance.unpauseCore( {from: accounts[0]}).then(function() {
    return coreInstance.paused.call().then(function(paused) {
        assert.equal(paused,false, "Contract is stll paused");
      });
  });
  });

 
  it("...should pause the contract.", function() {
      return coreInstance.pause( {from: accounts[0]}).then(function() {
      return coreInstance.paused.call().then(function(paused) {
        assert.equal(paused,true, "Contract is stll unpaused");
      });
    });
  });

  //Unpausing again to allow further processing
  it("...should un-pause the contract.", function() {
    return coreInstance.unpauseCore( {from: accounts[0]}).then(function() {
    return coreInstance.paused.call().then(function(paused) {
        assert.equal(paused,false, "Contract is stll paused");
      });
  });
  });


  //Create a drone
  it("...should create a drone.", function() {
    return manufacturingInstance.manufacturePromoDrone(5,6,accounts[0], {from: accounts[0]}).then(function() {
      return coreInstance.balanceOf(accounts[0]).then(function(balance) {
        assert.equal(balance,1, "Drone not created");
      });
    });
  });
 //Make sure the drones data has been setup correctly
  it("...should get drone data.", function(){
    return coreInstance.getDrone(0,{from: accounts[0]}).then(function(drone0){
      assert.equal(drone0[0],5,"Drone data not set correctly");
      assert.equal(drone0[5],6,"Drone data not set correctly");
    });
  });
//Ensure we can transfer drone ownership
  it("...should transfer drone ownership.", function(){
    return coreInstance.transfer(accounts[1],0,{from: accounts[0]}).then(function(){
      return coreInstance.balanceOf(accounts[1]).then(function(balance) {
        assert.equal(balance,1, "Drone not transfered");
      });
    });
  });

  //Put the drone up for sale
  
  //Bid on the drone
  
  //Ensure the drone has switched owner

  //Make another drone

  //Make a match

  //Take a match

  //Check winner

  //Check looser

  //Ensure the looser has learned from the fight

  //Transfer our cut

  //Test auto-creation of drones for auction

  //Bid on drones

  //Re-test auto-creation of drones for auction

  //Make sure their prices have updated based on previous bids

  //Test drone manufacuring from pre-set lines.

});
