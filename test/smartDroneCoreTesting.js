var SmartDroneCore = artifacts.require("./SmartDroneCore.sol");
var SaleClockAuction = artifacts.require("./SaleClockAuction.sol");
var AIScience = artifacts.require("./AIScience.sol")
var WarResolution = artifacts.require("./WarResolution.sol")
var Matchmaker = artifacts.require("./MatchMaker.sol")
var Manufacturing = artifacts.require("./Manufacturing")

contract('SmartDroneCore', function(accounts) {
  var coreInstance;
  var warResolutionInstance;
  var contraddress;
  it("...should set the EthManager.", function() {
    return SmartDroneCore.deployed().then(function(instance) {
      coreInstance = instance;
      return coreInstance.setEthManager("0x6fa871bb04d170ab91c2dabe191bda9f16be1af3", {from: "0x6fa871bb04d170ab91c2dabe191bda9f16be1af3"});
    }).then(function() {
      return coreInstance.ethManagerAddress.call();
    }).then(function(ethAddress) {
      assert.equal(ethAddress, "0x6fa871bb04d170ab91c2dabe191bda9f16be1af3", "The account was not set.");
    });
  });

  it("...should set the ConManager.", function() {
      return coreInstance.setConManager("0x6fa871bb04d170ab91c2dabe191bda9f16be1af3", {from: "0x6fa871bb04d170ab91c2dabe191bda9f16be1af3"}).then(function() {
      return coreInstance.conManagerAddress.call();
    }).then(function(ethAddress) {
      assert.equal(ethAddress, "0x6fa871bb04d170ab91c2dabe191bda9f16be1af3", "The account was not set.");
    });
  });

  it("...should set the TokManager.", function() {
      return coreInstance.setTokManager("0x6fa871bb04d170ab91c2dabe191bda9f16be1af3", {from: "0x6fa871bb04d170ab91c2dabe191bda9f16be1af3"}).then(function() {
      return coreInstance.tokManagerAddress.call();
    }).then(function(ethAddress) {
      assert.equal(ethAddress, "0x6fa871bb04d170ab91c2dabe191bda9f16be1af3", "The account was not set.");
    });
  });

  it("...should set the Auction contract.", function() {
       return SaleClockAuction.deployed().then(function(insta){
        saleInst = insta;
         coreInstance.setSaleAuctionAddress(saleInst.address,{from: "0x6fa871bb04d170ab91c2dabe191bda9f16be1af3"}).then(function(){
          return coreInstance.saleAuction.call().then(function(contra){
            assert.equal(contra,saleInst.address, "Matchmaking contract not set");
          });  
        });
      });
    });
 

  it("...should set the Matchmaking contract.", function() {
      matchMakerInstance = Matchmaker.new([coreInstance.address,9000],{from: "0x6fa871bb04d170ab91c2dabe191bda9f16be1af3"});
         coreInstance.setMatchmakerAddress(matchMakerInstance.address,{from: "0x6fa871bb04d170ab91c2dabe191bda9f16be1af3"}).then(function(){
          return coreInstance.matchMaker.call().then(function(contra){
            assert.equal(contra,matchMakerInstance.address, "Matchmaking contract not set");
          });  
        });
    });
  
    it("...should set the War Resolution contract.", function() {
      return WarResolution.deployed().then(function(warinst){
        warResolutionInstance = warinst;
        coreInstance.setWarAddress(warResolutionInstance.address,{from: "0x6fa871bb04d170ab91c2dabe191bda9f16be1af3"}).then(function(){
         return coreInstance.warResolution.call().then(function(contra){
           contraddress = contra;
           assert.equal(contra,warResolutionInstance.address, "War resolution contract not set");
         });  
       });
     });
   });

   it("...should set the Matchmaking contract.", function() {
    manufacturingInstance = Manufacturing.new([coreInstance.address],{from: "0x6fa871bb04d170ab91c2dabe191bda9f16be1af3"});
       coreInstance.setManufacturingAddress(manufacturingInstance.address,{from: "0x6fa871bb04d170ab91c2dabe191bda9f16be1af3"}).then(function(){
        return coreInstance.manufacturingAddress.call().then(function(contra){
          assert.equal(contra,manufacturingInstance.address, "Matchmaking contract not set");
        });  
      });
  });

  //This needs to be done by the secManager
  it("...should un-pause the contract.", function() {
    return coreInstance.unpauseCore( {from: "0x6fa871bb04d170ab91c2dabe191bda9f16be1af3"}).then(function() {
    return coreInstance.paused.call().then(function(paused) {
        assert.equal(paused,false, "Contract is stll paused");
      });
  });
  });

  //Doing this with an account other than the secManager, because any manager account should be able to pause in an emergency!
  it("...should pause the contract.", function() {
      return coreInstance.pause( {from: "0x6fa871bb04d170ab91c2dabe191bda9f16be1af3"}).then(function() {
      return coreInstance.paused.call().then(function(paused) {
        assert.equal(paused,true, "Contract is stll unpaused");
      });
    });
  });

  //Unpausing again to allow further processing
  it("...should un-pause the contract.", function() {
    return coreInstance.unpauseCore( {from: "0x6fa871bb04d170ab91c2dabe191bda9f16be1af3"}).then(function() {
    return coreInstance.paused.call().then(function(paused) {
        assert.equal(paused,false, "Contract is stll paused");
      });
  });
  });


  it("...should create a drone.", function() {
    return coreInstance.constructDrone(5,5,"0x6fa871bb04d170ab91c2dabe191bda9f16be1af3", {from: "0x6fa871bb04d170ab91c2dabe191bda9f16be1af3"}).then(function() {
      return coreInstance.balanceOf("0x6fa871bb04d170ab91c2dabe191bda9f16be1af3").then(function(balance) {
        assert.equal(balance,1, "Drone not created");
      });
    });
  });
/*
  it("...should get drone data.", function(){
    return coreInstance.smartDrones[0]({from: "0x6fa871bb04d170ab91c2dabe191bda9f16be1af3"}).then(function(droneArray){
      assert.equal(droneArray[0].sourceAI,5,"Drone data not set correctly");
    });
  });
*/
});
