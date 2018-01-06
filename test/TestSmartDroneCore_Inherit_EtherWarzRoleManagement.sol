pragma solidity ^0.4.17;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "contracts/Core/SmartDroneCore.sol";
import "contracts/Core/SmartDroneBase.sol";

contract TestSmartDroneCore_Inherit_EtherWarzRoleManagement {

  SmartDroneCore smartDroneCore;

  function testInheritence_EtherWarzRoleManagement_setSecManager() {
    smartDroneCore = new SmartDroneCore();
    
    smartDroneCore.setSecManager(this);

    Assert.equal(smartDroneCore.secManagerAddress(),this, "Address should match");

  }

  function testInheritence_EtherWarzRoleManagement_setConManager() {

    smartDroneCore.setConManager(this);

    Assert.equal(smartDroneCore.conManagerAddress(),this, "Address should match");

  }

  function testInheritence_EtherWarzRoleManagement_setEthManager() {

    smartDroneCore.setEthManager(this);

    Assert.equal(smartDroneCore.ethManagerAddress(),this, "Address should match");

  }

  function testInheritence_EtherWarzRoleManagement_setTokManager() {

    smartDroneCore.setTokManager(this);

    Assert.equal(smartDroneCore.tokManagerAddress(),this, "Address should match");

  }

}