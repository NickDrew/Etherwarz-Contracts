pragma solidity ^0.4.17;

import 'contracts/Core/SmartDroneAuction.sol';
import 'contracts/Manufacturing/ManufacturingInterface.sol';

contract SmartDroneMinting is SmartDroneAuction {

   

    ///@dev The address of the sibling contract that is used to control Drone manufacturing
    address public manufacturingAddress;

    ///@dev Update the address of the aMAtchMaker contract. Can only be called by the Contract Manager.
      function setManufacturingAddress(address _address) external onlyConManager {

        ManufacturingInterface candidateContract = ManufacturingInterface(_address);

        // NOTE: verify that a contract is what we expect
        require(candidateContract.isManufacturing());

        // Set the new contract address
        manufacturingAddress = _address; 
    }
 
    
    ///@dev Allows us to create promo drones and assign them directly to individuals
    /// @param _sourceAI the seed value for the Drones simple AI
    /// @param _lineId the physical structure of the Drone to be created, any value is accepted
    /// @param _owner the future owner of the created Drone. Default to contract Token Manager
    function constructDrone(uint64 _sourceAI, uint128 _lineId, address _owner) external {
        require(msg.sender == manufacturingAddress);
        address droneOwner = _owner;
        if(droneOwner == address(0)){
            droneOwner = tokManagerAddress;
        }
        _createDrone(_sourceAI, _lineId, _owner);
    }

    ///@dev Creates a new SmartDrone with the given AI/Line combo and
    ///creates an auction for it
    function createSmartDroneAuction(uint64 _sourceAI, uint128 _lineId,uint256 price, uint256 duration) external {
        require(msg.sender == manufacturingAddress);
        uint256 droneId = _createDrone(_sourceAI,_lineId,address(this));
        _approve(droneId, saleAuction);

        saleAuction.createAuction(droneId,price,0,duration,address(this));
    }

}