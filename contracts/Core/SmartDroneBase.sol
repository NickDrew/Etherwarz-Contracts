pragma solidity ^0.4.17;

import 'contracts/RoleManagement/EtherWarzRoleManagement.sol';
import 'contracts/Auctions/SaleClockAuction.sol';

///Some of the below contracts were adapted from those designed for use in the Cryptokitties DAP. Go check it out!  (https://www.cryptokitties.co/)
///Many thanks to Axiom Zen (https://www.axiomzen.co) and the Loom Network (https://loomx.io/) for their excellent work 
///pushing the boundries of Blockchain DAP development and providing excellent tutorials and learning resources for new DAP developers.

///@title Base contract for EtherWarz. Holds all common structs, events and base variables.
///@author Streamvade
///@dev See the EtherWarz contract documentation to understand how the various contract facets are linked and organised.
contract SmartDroneBase is EtherWarzRoleManagement {
    /*** EVENTS ***/
    
    /// @dev The Construct event is fired whenever a new Smart Drone comes into existence.
    event Construct(address owner, uint256 droneId, uint256 lineId, uint256 sourceAI);

    /// @dev Transfer event as defined in current draft of ERC721. Emitted every time a Smart Drones
    /// ownership is assigned, including self-duplication.
    event Transfer(address from, address to, uint256 tokenId);

    /*** DATA TYPES ***/
    /// @dev The main Smart Drone struct. Every Smart Drone in EtherWarz is represented by a copy of this structure.
    struct SmartDrone {
        //The Smart Drones "AI" is stored in these 256-bits. The AI will change as the Smart Drone looses fights. Self-duplicating drones
        //create a duplicate with an exact copy of their own sourceAI.
        bytes32 sourceAI;
        //The Smart Drones "AI" is stored in these 256-bits. The AI will change as the Smart Drone looses fights. Self-duplicating drones
        //create a duplicate with an exact copy of their own sourceAI.
        bytes32 oldSourceAI;
        //The lineId of the Smart Drone defines is physical construction. This will be defined when a new Smart Drone 
        //is constructed.
        bytes32 lineId;
        // The timestamp from the block when this Smart Drone came into existence.
        uint64 birthTime;
        // The next timestamp a Smart Drone will be able to fight again.
        uint64 cooldownEndBlock;
        //The total number of victories the Smart Drone has won.
        uint32 victories;
        //The total number of losses the Smart Drone has suffered.
        uint32 defeats;
        
    }

    /*** CONSTANTS ***/

    // An approximation of currently how many seconds are in-between blocks.
    uint256 public secondsPerBlock = 15;
    // Fight cooldown times
    uint32 public fightCooldown = uint32(5 minutes);


    /*** STORAGE  ***/
    /// @dev An array containing the SmartDrone struct for all Smart Drones in existence. ID 0 is the master production facility from which all new production lines are created.
    SmartDrone[] smartDrones;

    ///@dev A mapping from drone IDs to the address that owns them. All drones have
    /// some valid owner address, even gen0 drones are created with a non-sero owner.
    mapping(uint256=>address) public droneIndexToOwner;

    ///@dev A mapping from owner address to count of tokens that address owns.
    // Used internally inside balanceOf() to resolve ownership count.
    mapping(address=>uint256) ownershipTokenCount;

    ///@dev A mapping from DroneIDs to an address that has been approved to call
    /// transferFrom(). Each Drone can only have one approved address for transfer
    /// at any time. A zero value means no approval is outstanding.
    mapping (uint256 => address) public droneIndexToApproved;

    ///@dev A mapping from DroneIDs to an address that has been approved to use
    /// this Drone for fighting via fightWith(). Each drone can only have one approved
    /// address for fighting at any time. A zero value means no approval is outstanding.
    mapping (uint256 => address) public fightAllowedToAddress;

    ///@dev The address of the ClockAuction contract that handles sales of Drones. This
    /// same contract handles both peer-to-peer sales as well as the gen0 sales which are 
    /// initiated every 15 minutes.
    SaleClockAuction public saleAuction;

    ///@dev Assigns ownership of a specific Drone to an address.
    function _transfer(address _from, address _to, uint256 _tokenId)internal {
        //Since the number of drones is capped to 2^32 we can't overflow this
        ownershipTokenCount[_to]++;
        // transfer ownership
        droneIndexToOwner[_tokenId] = _to;
        //When creating new drones _from is 0x0, but we can't account that address!
        if (_from!=address(0)) {
            ownershipTokenCount[_from]--;
            //once the drone is transferred also clear fight allowances
            delete fightAllowedToAddress[_tokenId];
            // clear any previously approved ownership exchange
            delete droneIndexToApproved[_tokenId];
        }
        //Emit the transfer event.
        Transfer(_from,_to,_tokenId);
    }

    ///@dev An internal method that creates a new Smart Drone and stores it. This
    /// method doesn't do any checking and should only be called when the 
    /// input data is known to be valid. Will generate both a Constructed event and a Transfer event.
    ///@param _sourceAI The AI that will be used to determin how the SmartDrone fights
    ///@param _lineId The physical construction line used to determin the SmartDrones physical charactersitics.
    ///@param _owner The initial owner of the drone, must be non-zero (except for the Construcion Line, ID 0)
    function _createDrone(
        bytes32 _sourceAI,
        bytes32 _lineId,
        address _owner
    )
        internal
        returns (uint)
    {
        //The requires are not strictly necessary, our calling code should make
        //sure that these conditions are never broken. However! _createDrone() is already
        // an expensive call (for storage), and it doesn't hurt to be especially careful
        // to ensure our data structures are always valid.
        require(_lineId == bytes32(_lineId));

        SmartDrone memory _smartDrone = SmartDrone({sourceAI:_sourceAI,oldSourceAI:_sourceAI, birthTime:uint64(now),cooldownEndBlock:0,victories:0,defeats:0,lineId:_lineId});
        uint256 newDroneID = smartDrones.push(_smartDrone) - 1;
        //Just check to ensure we haven't created more than 4 billion drones!
        require(newDroneID == uint256(uint32(newDroneID)));
        // emit the construction event
        Construct(
            _owner,
            newDroneID,
            uint256(_smartDrone.lineId),
            uint256(_smartDrone.sourceAI)
        );

        //This will assign ownership, and also emit the Transfer event as
        //per ERC721 draft
        _transfer(0, _owner, newDroneID);
        return newDroneID;
    }

    // Any Manager can fix how many seconds per blocks are currently observed.
    function setSecondsPerBlock(uint256 secs) external onlyManager {
        require(secs<fightCooldown);
        secondsPerBlock = secs;
    }
}



