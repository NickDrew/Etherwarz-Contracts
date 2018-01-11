pragma solidity ^0.4.17;


import 'contracts/Tokens/ERC721.sol';
import 'contracts/Auctions/SaleClockAuction.sol';
import 'contracts/Core/SmartDroneMinting.sol';
import 'contracts/RoleManagement/EtherWarzRoleManagement.sol';
import 'contracts/War/WarInterface.sol';


//@title SmartDroneWar handles passing Drones off to the war interface and ensures Drones are not on sale and up for war at the same time
///@author StreamVade
///@dev Interface content to come later.
contract SmartDroneWar is SmartDroneMinting {


     ///@dev The address of the sibling contract that is used to control AI
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

    ///@dev The address of the sibling contract that is used to initiate a battles
    WarInterface public warInterface;

    ///@dev Update the address of the aIScience contract. Can only be called by the Contract Manager.
    ///@param _address An address of a aIScience contract instance to be used from this point forward.
    function setWarAddress(address _address) external onlyConManager {

        WarInterface candidateContract = WarInterface(_address);

        // NOTE: verify that a contract is what we expect
        require(candidateContract.isWarInterface());

        // Set the new contract address
        warInterface = candidateContract; 
    }
}