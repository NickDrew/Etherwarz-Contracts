pragma solidity ^0.4.17;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "contracts/Core/SmartDroneCore.sol";
import "contracts/Core/SmartDroneBase.sol";
import "contracts/Auctions/SaleClockAuction.sol";
import "contracts/AIScience/AIScienceInterface.sol";
import "contracts/Tokens/ERC721Metadata.sol";


contract TestSmartDroneCore_Inherit_SmartDroneOwnership_2 {

  SmartDroneCore smartDroneCore;

  function testInheritence_SmartDroneOwnership_transfer() {
    smartDroneCore = new SmartDroneCore();
    smartDroneCore.setConManager(this);
    SaleClockAuction saleClockAuction = new SaleClockAuction(smartDroneCore,9000);
    AIScienceInterface aIScienceInterface = new AIScienceInterface();
    smartDroneCore.setSaleAuctionAddress(saleClockAuction);
    smartDroneCore.setaIScienceAddress(aIScienceInterface);
    smartDroneCore.unpause();

    address bob = 0x627306090abaB3A6e1400e9345bC60c78a8BEf57;
    smartDroneCore.createPromoDrone(1234,1234,this);

    smartDroneCore.transfer(bob, 0);

    Assert.equal(smartDroneCore.balanceOf(bob), 1, "It should be 1");

  }

  function testInheritence_SmartDroneOwnership_totalSupply() {

    Assert.equal(smartDroneCore.totalSupply(), 1, "It should be 1");

  }

}