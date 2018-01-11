pragma solidity ^0.4.17;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "contracts/Core/SmartDroneCore.sol";
import "contracts/Core/SmartDroneWar.sol";

contract TestSmartDroneCore_Inherit_SmartDroneWar_1 {

  SmartDroneCore smartDroneCore;

   function testInheritence_SmartDroneWar_setaIScienceAddress() {
    smartDroneCore = new SmartDroneCore();
    smartDroneCore.setConManager(this);
    SaleClockAuction saleClockAuction = new SaleClockAuction(smartDroneCore,9000);
    AIScienceInterface aIScienceInterface = new AIScienceInterface();
    smartDroneCore.setSaleAuctionAddress(saleClockAuction);
    smartDroneCore.setaIScienceAddress(aIScienceInterface);
    smartDroneCore.unpause();

    Assert.equal(smartDroneCore.aIScience(),aIScienceInterface, "It should be the same address");

  }

}