pragma solidity ^0.4.17;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "contracts/Core/SmartDroneCore.sol";
import "contracts/Core/SmartDroneBase.sol";

contract TestSmartDroneCore_Inherit_SmartDroneBase {

  SmartDroneCore smartDroneCore;

  function testInheritence_SmartDroneBase_setSecondsPerBlock() {

    smartDroneCore = new SmartDroneCore();

    smartDroneCore.setSecondsPerBlock(uint256(30));

    Assert.equal(smartDroneCore.secondsPerBlock(), 30, "It should be 15");

  }

}