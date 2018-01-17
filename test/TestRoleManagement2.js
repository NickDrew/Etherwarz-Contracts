var SmartDroneCore = artifacts.require("./SmartDroneCore.sol");

contract('EtherWarzRoleManagement', function(accounts) {

  it("...should setup a Contract Manager", function() {
    return SmartDroneCore.deployed().then(function(instance) {
      smartDroneCore = instance;
      smartDroneCore.setConManager({address: accounts[1],from: accounts[0]});
    }).then(function() {
      return smartDroneCore.conManagerAddress.call();
    }).then(function(address) {
      assert.equal(address, accounts[1], "The address was not set as the contract.");
    });
  });
});
