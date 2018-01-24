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
       return Matchmaker.deployed().then(function(inst){
        matchMakerInstance = inst;
         coreInstance.setMatchmakerAddress(matchMakerInstance.address,{from: "0x6fa871bb04d170ab91c2dabe191bda9f16be1af3"}).then(function(){
          return coreInstance.matchMaker.call().then(function(contra){
            assert.equal(contra,matchMakerInstance.address, "Matchmaking contract not set");
          });  
        });
      });
    });
  

  it("...should set the AI Science contract.", function() {
       return AIScience.deployed().then(function(instai){
        aIScienceInstance = instai;
         coreInstance.setaIScienceAddress(aIScienceInstance.address,{from: "0x6fa871bb04d170ab91c2dabe191bda9f16be1af3"}).then(function(){
          return coreInstance.aIScience.call().then(function(contra){
            assert.equal(contra,aIScienceInstance.address, "AI Science contract not set");
          });  
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

  
  it("...should un-pause the contract.", function() {
      return coreInstance.unpauseCore( {from: "0x6fa871bb04d170ab91c2dabe191bda9f16be1af3"}).then(function() {
      return coreInstance.paused.call().then(function(paused) {
          assert.equal(paused,false, "Contract is stll paused");
        });
    });
  });

  it("...should pause the contract.", function() {
      return coreInstance.pause( {from: "0x6fa871bb04d170ab91c2dabe191bda9f16be1af3"}).then(function() {
      return coreInstance.paused.call().then(function(paused) {
        assert.equal(paused,true, "Contract is stll unpaused");
      });
    });
  });

  it("...should un-pause the contract.", function() {
    return coreInstance.unpauseCore( {from: "0x6fa871bb04d170ab91c2dabe191bda9f16be1af3"}).then(function() {
    return coreInstance.paused.call().then(function(paused) {
        assert.equal(paused,false, "Contract is stll paused");
      });
  });
  });
 //constructDrone(uint64 _sourceAI, uint128 _lineId, address _owner) external onlyTokManager {
  it("...should create a drone.", function() {
    return coreInstance.constructDrone(5,5,"0x6fa871bb04d170ab91c2dabe191bda9f16be1af3", {from: "0x6fa871bb04d170ab91c2dabe191bda9f16be1af3"}).then(function() {
      return coreInstance.balanceOf("0x6fa871bb04d170ab91c2dabe191bda9f16be1af3").then(function(balance) {
        assert.equal(balance,1, "Drone not created");
      });
    });
  });

  

});
