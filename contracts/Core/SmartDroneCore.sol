pragma solidity ^0.4.17;


import 'contracts/Tokens/ERC721.sol';
import 'contracts/Auctions/SaleClockAuction.sol';
import 'contracts/Core/SmartDroneMatchmaking.sol';
import 'contracts/RoleManagement/EtherWarzRoleManagement.sol';


//@title EtherWarz: Combat between Smart Drones that learn from their losses, on the Ethereum blockchain.
///@author StreamVade
///@dev The main EtherWarz contract, keeps tracks of drones to prevent rogue AI armageddon.
contract SmartDroneCore is SmartDroneMatchMaking {
    //This is the main EtherWarz contract and the endpoint of the core inheritence. It works in parallel to the SourceAI, Combat and Auction
    //contract collections to create the Blockchain portion of the EtherWarz game.

    //Set in case the core contract is broken and an upgrade is required
    address public newContractAddress;

    ///@notice Creates the main EtherWarz smart contract instance.
    function SmartDroneCore() public {
        //Starts paused.
        paused = true;

        // the creator of the contract is the initial security manager
        secManagerAddress = msg.sender;

        // the creator of the contract is also the initial token manager
        tokManagerAddress = msg.sender;
    }

    /// @dev Used to mark the smart contract as upgraded, in case there is a serious
    /// breaking bug. This method does nothing but keep track of the new contracts and
    /// emit a message indicating that the new address is set. It's up to clients of this
    /// contract to update to the new contract address in that case. (This contract will
    /// be paused indefinitely if such an upgrade takes place.)
    function setNewAddress(address _v2Address) external onlyConManager whenPaused {
        // See README.md for upgrade plan
        newContractAddress = _v2Address;
        ContractUpgrade(_v2Address);
    }

    ///@dev Reject all Ether from  being sent here, unless it's from one of
    // our designated contracts
    /*function() external payable {
        require(
            msg.sender == address(saleAuction)
        );
    }*/

    /// @notice Returns all the relevant information about a specific Smart Drone.
    /// @param _id The ID of the Drone of interest.
    function getDrone(uint256 _id) external view returns (uint64 sourceAI, uint256 birthTime, uint256 cooldownEndBlock, uint256 victories, uint256 defeats, uint128 lineId)
    {
        SmartDrone storage drone = smartDrones[_id];
        sourceAI = uint64(drone.sourceAI);
        birthTime = uint256(drone.birthTime);
        cooldownEndBlock = uint256(drone.cooldownEndBlock);
        victories = uint256(drone.victories);
        defeats = uint256(drone.defeats);
        lineId = uint128(drone.lineId);
    }

    //@dev Override unpause so it requires all external contract addresses
    /// to be set before contract can be unpaused. Also, we can't have
    /// newContractAddress set either, because then the contract was upgraded.
    /// @notice This is public rather than external so we can call super.unpause
    /// without using an expensive CALL.
    function unpauseCore() public onlySecManager whenPaused {
        require(saleAuction != address(0));
        require(matchMaker != address(0));
        require(warResolution != address(0));
        require(manufacturingAddress != address(0));
        require(newContractAddress == address(0));
        //Actually unpause the contract.
        unpause();
    }

    // @dev Allows the Ethereum manager to capture the balance available to the contract.
    function withdrawBalance() external onlyEthManager {
        ethManagerAddress.send(this.balance);
    }
}
