pragma solidity ^0.4.17;


import 'contracts/Tokens/ERC721.sol';
import 'contracts/Auctions/SaleClockAuction.sol';
import 'contracts/Core/SmartDroneMinting.sol';
import 'contracts/RoleManagement/EtherWarzRoleManagement.sol';
import 'contracts/War/WarResolution.sol';
import 'contracts/AIScience/AIScience.sol';


//@title SmartDroneWar handles passing Drones off to the war interface and ensures Drones are not on sale and up for war at the same time
///@author StreamVade
///@dev Interface content to come later.
contract SmartDroneWar is SmartDroneMinting {


     ///@dev The address of the sibling contract that is used to control AI
    AIScience public aIScience;

    ///@dev Update the address of the aIScience contract. Can only be called by the Contract Manager.
    ///@param _address An address of a aIScience contract instance to be used from this point forward.
    function setaIScienceAddress(address _address) external onlyConManager {

        AIScience candidateContract = AIScience(_address);

        // NOTE: verify that a contract is what we expect
        require(candidateContract.isAIScience());

        // Set the new contract address
        aIScience = candidateContract; 
    }

    ///@dev The address of the sibling contract that is used to initiate a battles
    WarResolution public warResolution;

    ///@dev Update the address of the aIScience contract. Can only be called by the Contract Manager.
    ///@param _address An address of a aIScience contract instance to be used from this point forward.
    function setWarAddress(address _address) external onlyConManager {

        WarResolution candidateContract = WarResolution(_address);

        // NOTE: verify that a contract is what we expect
        require(candidateContract.isWarInterface());

        // Set the new contract address
        warResolution = candidateContract; 
    }

    
}