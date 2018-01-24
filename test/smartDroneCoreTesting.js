var SmartDroneCore = artifacts.require("./SmartDroneCore.sol");
var SaleClockAuction = artifacts.require("./SaleClockAuction.sol");
var AIScience = artifacts.require("./AIScience.sol")
var WarResolution = artifacts.require("./WarResolution.sol")
var Matchmaker = artifacts.require("./MatchMaker.sol")

contract('SmartDroneCore', function(accounts) {
  var coreInstance;
  var warResolutionInstance;
  var contraddress;
  it("...should set the EthManager.", function() {
    return SmartDroneCore.deployed().then(function(instance) {
      coreInstance = instance;
      return coreInstance.setEthManager(accounts[1], {from: accounts[0]});
    }).then(function() {
      return coreInstance.ethManagerAddress.call();
    }).then(function(ethAddress) {
      assert.equal(ethAddress, accounts[1], "The account was not set.");
    });
  });

  it("...should set the ConManager.", function() {
      return coreInstance.setConManager(accounts[1], {from: accounts[0]}).then(function() {
      return coreInstance.conManagerAddress.call();
    }).then(function(ethAddress) {
      assert.equal(ethAddress, accounts[1], "The account was not set.");
    });
  });

  it("...should set the TokManager.", function() {
      return coreInstance.setTokManager(accounts[1], {from: accounts[0]}).then(function() {
      return coreInstance.tokManagerAddress.call();
    }).then(function(ethAddress) {
      assert.equal(ethAddress, accounts[1], "The account was not set.");
    });
  });

  it("...should set the Auction contract.", function() {
       return SaleClockAuction.deployed().then(function(insta){
        saleInst = insta;
         coreInstance.setSaleAuctionAddress(saleInst.address,{from: accounts[1]}).then(function(){
          return coreInstance.saleAuction.call().then(function(contra){
            assert.equal(contra,saleInst.address, "Matchmaking contract not set");
          });  
        });
      });
    });
 

  it("...should set the Matchmaking contract.", function() {
       return Matchmaker.deployed().then(function(inst){
        matchMakerInstance = inst;
         coreInstance.setMatchmakerAddress(matchMakerInstance.address,{from: accounts[1]}).then(function(){
          return coreInstance.matchMaker.call().then(function(contra){
            assert.equal(contra,matchMakerInstance.address, "Matchmaking contract not set");
          });  
        });
      });
    });
  

  it("...should set the AI Science contract.", function() {
       return AIScience.deployed().then(function(instai){
        aIScienceInstance = instai;
         coreInstance.setaIScienceAddress(aIScienceInstance.address,{from: accounts[1]}).then(function(){
          return coreInstance.aIScience.call().then(function(contra){
            assert.equal(contra,aIScienceInstance.address, "AI Science contract not set");
          });  
        });
      });
    });

    it("...should set the War Resolution contract.", function() {
      return WarResolution.deployed().then(function(warinst){
        warResolutionInstance = warinst;
        coreInstance.setWarAddress(warResolutionInstance.address,{from: accounts[1]}).then(function(){
         return coreInstance.warResolution.call().then(function(contra){
           contraddress = contra;
           assert.equal(contra,warResolutionInstance.address, "War resolution contract not set");
         });  
       });
     });
   });

  //This needs to be done by the secManager
  it("...should un-pause the contract.", function() {
    return coreInstance.unpauseCore( {from: accounts[0]}).then(function() {
    return coreInstance.paused.call().then(function(paused) {
        assert.equal(paused,false, "Contract is stll paused");
      });
  });
  });

  //Doing this with an account other than the secManager, because any manager account should be able to pause in an emergency!
  it("...should pause the contract.", function() {
      return coreInstance.pause( {from: accounts[1]}).then(function() {
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


  it("...should create a drone.", function() {
    return coreInstance.constructDrone(5,5,accounts[1], {from: accounts[1]}).then(function() {
      return coreInstance.balanceOf(accounts[1]).then(function(balance) {
        assert.equal(balance,1, "Drone not created");
      });
    });
  });
/*
  it("...should get drone data.", function(){
    return coreInstance.smartDrones[0]({from: accounts[1]}).then(function(droneArray){
      assert.equal(droneArray[0].sourceAI,5,"Drone data not set correctly");
    });
  });
*/
});
