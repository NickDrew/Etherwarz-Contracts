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

 

  function testInheritence_SmartDroneManufacturing_constructDrone() {
     smartDroneCore = new SmartDroneCore();
    smartDroneCore.setConManager(this);
    SaleClockAuction saleClockAuction = new SaleClockAuction(smartDroneCore,9000);
    AIScienceInterface aIScienceInterface = new AIScienceInterface();
    smartDroneCore.setSaleAuctionAddress(saleClockAuction);
    smartDroneCore.setaIScienceAddress(aIScienceInterface);
    smartDroneCore.unpause();

    uint128 newLineId = uint128(1234);
    uint64 newAI = uint64(1234);
    uint256 newDroneId = smartDroneCore.constructDrone(newLineId,newAI);

    Assert.equal(smartDroneCore.ownerOf(newDroneId),this, "It should be the same");

  }

}