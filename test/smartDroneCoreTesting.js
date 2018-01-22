var SmartDroneCore = artifacts.require("./SmartDroneCore.sol");
var SaleClockAuction = artifacts.require("./SaleClockAuction.sol");
var AIScience = artifacts.require("./AIScience.sol")
var WarResolution = artifacts.require("./WarResolution.sol")
var Matchmaker = artifacts.require("./Matchmaker.sol")

contract('SmartDroneCore', function(accounts) {

  it("...should set the EthManager.", function() {
    return SmartDroneCore.deployed().then(function(instance) {
      coreInstance = instance;
      return coreInstance.setEthManager("0x2d693f990e7fc837726a67f838b5be96d13f3175", {from: "0x2d693f990e7fc837726a67f838b5be96d13f3175"});
    }).then(function() {
      return coreInstance.ethManagerAddress.call();
    }).then(function(ethAddress) {
      assert.equal(ethAddress, "0x2d693f990e7fc837726a67f838b5be96d13f3175", "The account was not set.");
    });
  });

  it("...should set the ConManager.", function() {
    return SmartDroneCore.deployed().then(function(instance) {
      coreInstance = instance;
      return coreInstance.setConManager("0x2d693f990e7fc837726a67f838b5be96d13f3175", {from: "0x2d693f990e7fc837726a67f838b5be96d13f3175"});
    }).then(function() {
      return coreInstance.conManagerAddress.call();
    }).then(function(ethAddress) {
      assert.equal(ethAddress, "0x2d693f990e7fc837726a67f838b5be96d13f3175", "The account was not set.");
    });
  });

  it("...should set the TokManager.", function() {
    return SmartDroneCore.deployed().then(function(instance) {
      coreInstance = instance;
      return coreInstance.setTokManager("0x2d693f990e7fc837726a67f838b5be96d13f3175", {from: "0x2d693f990e7fc837726a67f838b5be96d13f3175"});
    }).then(function() {
      return coreInstance.tokManagerAddress.call();
    }).then(function(ethAddress) {
      assert.equal(ethAddress, "0x2d693f990e7fc837726a67f838b5be96d13f3175", "The account was not set.");
    });
  });

 /* it("...should set the Auction contract.", function() {
    return SmartDroneCore.deployed().then(function(instance) {
      coreInstance = instance;
       return SaleClockAuction.deployed().then(function(insta){
        saleInst = insta;
         coreInstance.setMatchmakerAddress(saleInst.address,{from: accounts[2]}).then(function(){
          return coreInstance.matchMaker.call().then(function(contra){
            assert.equal(contra,saleInst.address, "Matchmaking contract not set");
          });  
        });
      });
    });
  });*/

 /* it("...should set the AI Science contract.", function() {
    return SmartDroneCore.deployed().then(function(instance) {
      coreInstance = instance;
       return Matchmaker.deployed().then(function(inst){
        aIScienceInstance = inst;
         coreInstance.setMatchmakerAddress(aIScienceInstance.address,{from: "0x2d693f990e7fc837726a67f838b5be96d13f3175"}).then(function(){
          return coreInstance.matchMaker.call().then(function(contra){
            assert.equal(contra,aIScienceInstance.address, "AI Science contract not set");
          });  
        });
      });
    });
  });

  it("...should set the War Resolution contract.", function() {
    return SmartDroneCore.deployed().then(function(instance) {
      coreInstance = instance;
      warResolutionInstance = WarResolution.deployed();
      coreInstance.setaIScienceAddress(warResolutionInstance,{from: "0x2d693f990e7fc837726a67f838b5be96d13f3175"}).then(function(){
        return coreInstance.warResolution.call().then(function(contra){
          assert.equal(contra,warResolutionInstance, "War Resolution contract not set");
        });  
      });
    });
  });

  it("...should set the Matchmaking contract.", function() {
    return SmartDroneCore.deployed().then(function(instance) {
      coreInstance = instance;
       return Matchmaker.deployed().then(function(inst){
        matchMakerInstance = inst;
         coreInstance.setMatchmakerAddress(matchMakerInstance.address,{from: "0x2d693f990e7fc837726a67f838b5be96d13f3175"}).then(function(){
          return coreInstance.matchMaker.call().then(function(contra){
            assert.equal(contra,matchMakerInstance.address, "Matchmaking contract not set");
          });  
        });
      });
    });
  });
  
  it("...should un-pause the contract.", function() {
    return SmartDroneCore.deployed().then(function(instance) {
      coreInstance = instance;
      return coreInstance.unpause( {from: "0x2d693f990e7fc837726a67f838b5be96d13f3175"});
    }).then(function() {
      return coreInstance.paused.call();
    }).then(function(paused) {
      assert.equal(paused,false, "Contract is stll paused");
    });
  });

  it("...should pause the contract.", function() {
    return SmartDroneCore.deployed().then(function(instance) {
      coreInstance = instance;
      return coreInstance.pause( {from: "0x2d693f990e7fc837726a67f838b5be96d13f3175"});
    }).then(function() {
      return coreInstance.paused.call();
    }).then(function(paused) {
      assert.equal(paused,true, "Contract is stll unpaused");
    });
  });

  */

});
