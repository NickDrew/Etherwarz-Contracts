pragma solidity ^0.4.17;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "contracts/Core/SmartDroneCore.sol";

contract TestSmartDroneCore {

  function testContract() {
    SmartDroneCore smartDroneCore = SmartDroneCore(DeployedAddresses.SmartDroneCore());

    Assert.equal(smartDroneCore.MANLINE_STARTING_PRICE(), 10 finney, "It should be 10 finney");
  }

}