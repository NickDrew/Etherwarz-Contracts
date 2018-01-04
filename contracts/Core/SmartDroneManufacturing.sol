pragma solidity ^0.4.17;

import 'contracts/Core/SmartDroneOwnership.sol';
import 'contracts/AIScience/AIScienceInterface.sol';


///@title A facet of EtherWarzCore that manages Drone Manufacturing
contract SmartDroneManufacturing is SmartDroneOwnership {

    ///@dev The address of the sibling contract that is used to initiate a new sourceAI
    AIScienceInterface public aIScience;

    ///@dev Update the address of the aIScience contract. Can only be called by the Contract Manager.
    ///@param _address An address of a aIScience contract instance to be used from this point forward.
    function setaIScienceAddress(address _address) external onlyConManager {

        AIScienceInterface candidateContract = AIScienceInterface(_address);

        // NOTE: verify that a contract is what we expect
        require(candidateContract.isAIScience());

        // Set the new contract address
        aIScience = candidateContract; 
    }

    function constructDrone(bytes32 _lineId) external whenNotPaused returns(uint256) {
        //Call the AI generation operation
        bytes32 newAISource = aIScience.generateNew();

        // Make the new drone!
        address owner = tokManagerAddress;
        uint256 droneID = _createDrone(newAISource, _lineId, owner);
        return droneID;
    }
}

