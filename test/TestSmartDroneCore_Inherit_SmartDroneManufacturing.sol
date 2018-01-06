pragma solidity ^0.4.17;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "contracts/Core/SmartDroneCore.sol";
import "contracts/Core/SmartDroneBase.sol";
import "contracts/Core/SmartDroneManufacturing.sol";
import "contracts/Auctions/SaleClockAuction.sol";
import "contracts/AIScience/AIScienceInterface.sol";
import "contracts/Tokens/ERC721Metadata.sol";


contract TestSmartDroneCore_Inherit_SmartDroneManufacturing {

  SmartDroneCore smartDroneCore;

  function testInheritence_SmartDroneManufacturing_setaIScienceAddress() {
    smartDroneCore = new SmartDroneCore();
    smartDroneCore.setConManager(this);
    SaleClockAuction saleClockAuction = new SaleClockAuction(smartDroneCore,9000);
    AIScienceInterface aIScienceInterface = new AIScienceInterface();
    smartDroneCore.setSaleAuctionAddress(saleClockAuction);
    smartDroneCore.setaIScienceAddress(aIScienceInterface);
    smartDroneCore.unpause();

  /*
    address bob = 0x627306090abaB3A6e1400e9345bC60c78a8BEf57;
    smartDroneCore.createPromoDrone(bytes32('a'),bytes32('b'),this);

    smartDroneCore.transfer(bob, 0);
*/
    Assert.equal(smartDroneCore.aIScience(),aIScienceInterface, "It should be the same address");

  }

  function testInheritence_SmartDroneManufacturing_constructDrone() {
    bytes32 newLineId = bytes32(1234);
    uint256 newDroneId = smartDroneCore.constructDrone(newLineId);

    Assert.equal(smartDroneCore.ownerOf(newDroneId),this, "It should be the same");

  }

}