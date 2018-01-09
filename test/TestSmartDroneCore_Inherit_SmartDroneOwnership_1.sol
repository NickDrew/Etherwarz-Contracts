pragma solidity ^0.4.17;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "contracts/Core/SmartDroneCore.sol";
import "contracts/Core/SmartDroneBase.sol";
import "contracts/Auctions/SaleClockAuction.sol";
import "contracts/AIScience/AIScienceInterface.sol";
import "contracts/Tokens/ERC721Metadata.sol";


contract TestSmartDroneCore_Inherit_SmartDroneOwnership_1 {

  SmartDroneCore smartDroneCore;

  function testInheritence_SmartDroneOwnership_setMetadataAddress() {
    smartDroneCore = new SmartDroneCore();
    smartDroneCore.setConManager(this);
    ERC721Metadata eRC721Metadata = new ERC721Metadata();
    smartDroneCore.setMetadataAddress(eRC721Metadata);
    Assert.equal(smartDroneCore.erc721Metadata(), eRC721Metadata, "It should be the same address");

  }

  function testInheritence_SmartDroneOwnership_balanceOf() {
    smartDroneCore.createPromoDrone(uint64(1),uint128(1),this);
    Assert.equal(smartDroneCore.balanceOf(this), 1, "It should be 1");
  }

}


