pragma solidity ^0.4.17;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "contracts/Core/SmartDroneCore.sol";
import "contracts/Core/SmartDroneBase.sol";
import "contracts/Core/SmartDroneManufacturing.sol";
import "contracts/Auctions/SaleClockAuction.sol";
import "contracts/AIScience/AIScienceInterface.sol";
import "contracts/Tokens/ERC721Metadata.sol";


contract TestSmartDroneCore_Inherit_SmartDroneAuction {

  SmartDroneCore smartDroneCore;

  function testInheritence_SmartDroneManufacturing_setSaleAuctionAddress() {
    smartDroneCore = new SmartDroneCore();  
    smartDroneCore.setConManager(this);
    SaleClockAuction saleClockAuction = new SaleClockAuction(smartDroneCore,9000);
    smartDroneCore.setSaleAuctionAddress(saleClockAuction);
   
  /*
    address bob = 0x627306090abaB3A6e1400e9345bC60c78a8BEf57;
    smartDroneCore.createPromoDrone(bytes32('a'),bytes32('b'),this);

    smartDroneCore.transfer(bob, 0);
*/
    Assert.equal(smartDroneCore.saleAuction(),saleClockAuction, "It should be the same address");

  }


  function testInheritence_SmartDroneManufacturing_createSaleAuction() {
 
    AIScienceInterface aIScienceInterface = new AIScienceInterface();
    
    smartDroneCore.setaIScienceAddress(aIScienceInterface);
    smartDroneCore.unpause();

    bytes32 newLineId = bytes32(1234);
    uint256 newDroneId = smartDroneCore.constructDrone(newLineId);
    uint256 startPrice = uint256(10);
    uint256 endPrice = uint256(20);
    uint256 duration = uint256(60 minutes);

    smartDroneCore.createSaleAuction(newDroneId,startPrice,endPrice,duration);

    Assert.equal(smartDroneCore.saleAuction().getCurrentPrice(newDroneId),startPrice, "It should be the same");

  }

}
