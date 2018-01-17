var SmartDroneCore = artifacts.require("./SmartDroneCore.sol");
var SaleClockAuction = artifacts.require("./SaleClockAuction.sol");

contract('SmartDroneCore', function(accounts) {

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
    return SmartDroneCore.deployed().then(function(instance) {
      coreInstance = instance;
      return coreInstance.setConManager(accounts[2], {from: accounts[0]});
    }).then(function() {
      return coreInstance.conManagerAddress.call();
    }).then(function(ethAddress) {
      assert.equal(ethAddress, accounts[2], "The account was not set.");
    });
  });

  it("...should set the TokManager.", function() {
    return SmartDroneCore.deployed().then(function(instance) {
      coreInstance = instance;
      return coreInstance.setTokManager(accounts[3], {from: accounts[0]});
    }).then(function() {
      return coreInstance.tokManagerAddress.call();
    }).then(function(ethAddress) {
      assert.equal(ethAddress, accounts[3], "The account was not set.");
    });
  });

  

  it("...should unpause the contract.", function() {
    return SmartDroneCore.deployed().then(function(instance) {
    coreInstance = instance;
    let auctionInstance = SaleClockAuction.deployed();
    coreInstance.setSaleAuctionAddress(auctionInstance,{from: accounts[0]}).then(function(){
      coreInstance.unpause({from: accounts[0]});
      return coreInstance.paused.call().then(function(paused){
        assert.equal(paused,false, "Contract is stll paused");
      });  
    });
    });
  });

  it("...should pause the contract.", function() {
    return SmartDroneCore.deployed().then(function(instance) {
      coreInstance = instance;
      return coreInstance.pause( {from: accounts[0]});
    }).then(function() {
      return coreInstance.paused.call();
    }).then(function(paused) {
      assert.equal(paused,true, "Contract is stll unpaused");
    });
  });

  

});
