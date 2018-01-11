pragma solidity ^0.4.17;

import 'contracts/Core/SmartDroneOwnership.sol';
import 'contracts/AIScience/AIScienceInterface.sol';
import 'contracts/RoleManagement/EtherWarzRoleManagement.sol';

///@title A facet of EtherWarzCore that manages Drone Manufacturing
contract SmartDroneManufacturing is SmartDroneOwnership {

   

    function constructDrone(uint128 _lineId, uint64 _sourceAIID) external whenNotPaused onlyTokManager returns(uint256) {
        
        // Make the new drone!
        address owner = tokManagerAddress;
        uint256 droneID = _createDrone(_sourceAIID, _lineId, owner);
        return droneID;
    }
}

