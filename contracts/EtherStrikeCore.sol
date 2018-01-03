pragma solidity ^0.4.17;

import 'contracts/EtherStrikeRoleManagement.sol';
import 'contracts/Tokens/ERC721.sol';
import 'contracts/Auctions/Auction.sol';

///Some of the below contracts were adapted from those designed for use in the Cryptokitties DAP. Go check it out!  (https://www.cryptokitties.co/)
///Many thanks to Axiom Zen (https://www.axiomzen.co) and the Loom Network (https://loomx.io/) for their excellent work 
///pushing the boundries of Blockchain DAP development and providing excellent tutorials and learning resources for new DAP developers.

///@title Base contract for EtherStrike. Holds all common structs, events and base variables.
///@author Streamvade
///@dev See the EtherStrike contract documentation to understand how the various contract facets are linked and organised.
contract SmartDroneBase is EtherStrikeRoleManagement {
    /*** EVENTS ***/
    
    /// @dev The Construct event is fired whenever a new Smart Drone comes into existence.
    event Construct(address owner, uint256 droneId, uint256 lineId, uint256 sourceAI);

    /// @dev Transfer event as defined in current draft of ERC721. Emitted every time a Smart Drones
    /// ownership is assigned, including self-duplication.
    event Transfer(address from, address to, uint256 tokenId);

    /*** DATA TYPES ***/
    /// @dev The main Smart Drone struct. Every Smart Drone in EtherStrike is represented by a copy of this structure.
    struct SmartDrone {
        //The Smart Drones "AI" is stored in these 256-bits. The AI will change as the Smart Drone looses fights. Self-duplicating drones
        //create a duplicate with an exact copy of their own sourceAI.
        uint256 sourceAI;
        // The timestamp from the block when this Smart Drone came into existence.
        uint64 birthTime;
        // The next timestamp a Smart Drone will be able to fight again.
        uint64 cooldownEndBlock;
        //The total number of victories the Smart Drone has won.
        uint32 victories;
        //The total number of losses the Smart Drone has suffered.
        uint32 defeats;
        //The lineId of the Smart Drone defines is physical construction. This will be defined when a new Smart Drone 
        //is constructed.
        uint32 lineId;
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
        uint256 _sourceAI,
        uint32 _lineId,
        address _owner
    )
        internal
        returns (uint)
    {
        //The requires are not strictly necessary, our calling code should make
        //sure that these conditions are never broken. However! _createDrone() is already
        // an expensive call (for storage), and it doesn't hurt to be especially careful
        // to ensure our data structures are always valid.
        require(_lineId == uint256(uint32(_lineId)));

        SmartDrone memory _smartDrone = SmartDrone({sourceAI:_sourceAI, birthTime:uint64(now),cooldownEndBlock:0,victories:0,defeats:0,lineId:_lineId});
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

/// @title The external contract that is responsible for generating metadata for drones,
///  it has one function that will return the data as bytes.
contract ERC721Metadata {
    /// @dev Given a token Id, returns a byte array that is supposed to be converted into string.
    function getMetadata(uint256 _tokenId, string) public pure returns (bytes32[4] buffer, uint256 count) {
        if (_tokenId == 1) {
            buffer[0] = "Hello World! :D";
            count = 15;
        } else if (_tokenId == 2) {
            buffer[0] = "I would definitely choose a medi";
            buffer[1] = "um length string.";
            count = 49;
        } else if (_tokenId == 3) {
            buffer[0] = "Lorem ipsum dolor sit amet, mi e";
            buffer[1] = "st accumsan dapibus augue lorem,";
            buffer[2] = " tristique vestibulum id, libero";
            buffer[3] = " suscipit varius sapien aliquam.";
            count = 128;
        }
    }
}

/// @title No, you don't get to see this :P
contract AIScienceInterface {
    ///@dev simply a boolean to indicate this is the contract we expect to be
    function isAIScience() public pure returns (bool) {
        return true;
    }

    function generateNew() public pure returns (uint256) {
       uint256 generatedAiSource = 0;
       
       return generatedAiSource; 
    }
}

///@title Manages Drone ownership. Compliant with the draft version of ERC-721.
///@author Streamvade
///@dev See the EtherStrikeCore documentation to understand how the various contract facets are arranged.
contract SmartDroneOwnership is SmartDroneBase, ERC721 {
    
    ///@notice Name and symbol of the non fungible token, as defined in ERC721
    string public constant name = "SmartDrones";
    string public constant symbol = "SD";

    // The contract that will return kitty metadata
    ERC721Metadata public erc721Metadata;

    bytes4 constant InterfaceSignature_ERC165 = bytes4(keccak256('supportsInterface(bytes4)'));

    bytes4 constant InterfaceSignature_ERC721 = bytes4(keccak256('name()')) ^ bytes4(keccak256('symbol()')) ^ bytes4(keccak256('totalSupply()')) ^ bytes4(keccak256('balanceOf(address)')) ^ bytes4(keccak256('ownerOf(uint256)')) ^ bytes4(keccak256('approve(address,uint256)')) ^ bytes4(keccak256('transfer(address,uint256)')) ^ bytes4(keccak256('transferFrom(address,address,uint256)')) ^ bytes4(keccak256('tokensOfOwner(address)')) ^ bytes4(keccak256('tokenMetadata(uint256,string)'));

    /// @notice Introspection interface as per ERC-165 (https://github.com/ethereum/EIPs/issues/165).
    ///  Returns true for any standardized interfaces implemented by this contract. We implement
    ///  ERC-165 (obviously!) and ERC-721.
    function supportsInterface(bytes4 _interfaceID) external view returns (bool) {
        //DEBUG ONLY
        //require((InterfaceSignature_ERC165 == 0x01ffc9a7) && (InterfaceSignature_ERC721 == 0x9a20483d));

        return ((_interfaceID == InterfaceSignature_ERC165) || (_interfaceID == InterfaceSignature_ERC721));
    }

    ///@dev Set the address of the sibling contract that tracks metadata.
    /// Contract Manager only.
    function setMetadataAddress(address _contractAddress) public onlyConManager {
        erc721Metadata = ERC721Metadata(_contractAddress);
    }

    // Internal utility functions: These functions all assume that their input arguments
    // are valid. We leave it to public methods to sanitize their inputs and follow
    // the required logic.

    ///@dev Checks if a given address is the current owner of a particular Drone.
    ///@param _claimant the address we are validating against.
    ///@param _tokenId drone id, only valid when > 0
    function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
        return droneIndexToOwner[_tokenId] == _claimant;
    }
  
    /// @dev Checks if a given address currently has transferApproval for a particular Drone.
    /// @param _claimant the address we are confirming drone is approved for.
    /// @param _tokenId drone id, only valid when >0
    function _approvedFor(address _claimant, uint256 _tokenId) internal view returns (bool) {
        return droneIndexToApproved[_tokenId] == _claimant;
    }
    /// @dev Marks an address as being approved for transferFrom(), overwriting any previous
    ///  approval. Setting _approved to address(0) clears all transfer approval.
    ///  NOTE: _approve() does NOT send the Approval event. This is intentional because
    ///  _approve() and transferFrom() are used together for putting Drones on auction, and
    ///  there is no value in spamming the log with Approval events in that case.
    function _approve(uint256 _tokenId, address _approved) internal {
        droneIndexToApproved[_tokenId] = _approved;
    }

    /// @notice Returns the number of Drones owned by a specific address.
    /// @param _owner The owner address to check.
    /// @dev Required for ERC-721 compliance
    function balanceOf(address _owner) public view returns (uint256 count) {
        return ownershipTokenCount[_owner];
    }

    /// @notice Transfers a Drone to another address. May result in drone loss if the target contract is not aware of ERC-721.
    /// ~param _to The address of the recipient, can be a user or contract.
    /// @param _tokenId The ID of the Drone to transfer.
    /// @dev Required for ERC-721 compliance.
    function transfer(address _to,uint256 _tokenId) external whenNotPaused {
        // Safety check to prevent against an unexpected 0x0 default.
        require(_to != address(0));
        //This contract should never own any drones.
        require(_to != address(this));
        //Auction contracts should only take ownership of drones through the allow + transferFrom flow.
        require(_to != address(saleAuction));

        //You can only send you own drone.
        require(_owns(msg.sender,_tokenId));

        //Reassign ownership, clear pending approvals, emit Transfer event
        _transfer(msg.sender,_to,_tokenId);
    }

    /// @notice Grant another address the right to transfer a specific Drone via
    /// transferFrom(). This is the preferred flow for transfering NFTs to contracts.
    /// @param _to The address to be granted transfer approval. Pass address(0) to
    /// clear all approvals.
    /// @param _tokenId The ID of the Drone that can be transferred if this call succeeds.
    /// @dev Required for ERC-721 compliance.
    function approve(address _to,uint256 _tokenId) external whenNotPaused {
        //Only an owner can grant transfer approval.
        require(_owns(msg.sender, _tokenId));

        //Register the approval (replacing any previous approval).
        _approve(_tokenId, _to);

        //Emit approval event.
        Approval(msg.sender,_to,_tokenId);
    }

    /// @notice Transfer a Drone owned by another address, for which the calling address
    /// has previously been granted transfer approval by the owner.
    /// @param _from The address that owns the Drone to be transfered.
    /// @param _to The address that should take ownership of the Drone. Can be any address, including the caller.
    /// @param _tokenId The ID of the Drone to be transferred.
    /// @dev Required for ERC-721 compliance.
    function transferFrom(address _from,address _to,uint256 _tokenId) external whenNotPaused {
        // Safety check to prevent against an unexpected 0x0 default.
        require(_to != address(0));
        //Disallow transfers to this contract to prevent accidental misuse.
        require(_to != address(this));
        //Check for approval and valid ownership
        require(_approvedFor(msg.sender, _tokenId));
        require(_owns(_from, _tokenId));
        //Reassign ownership (also clears pending approvals and emits Transfer event).
        _transfer(_from, _to, _tokenId);
    }

    ///@notice Returns the total number of Smart Drones currently in existence.
    /// @dev Required for ERC-721 compliance.
    function totalSupply() public view returns(uint) {
        return smartDrones.length - 1;
    }
    
    ///@notice Returns the address currently assigned ownership of a given Drone.
    /// @dev Required for ERC-721 compliance.
    function ownerOf(uint256 _tokenId) external view returns(address owner) {
        owner = droneIndexToOwner[_tokenId];
        require(owner != address(0));
    }

    /// @notice Returns a list of all Drone IDs assigned to an address.
    /// @param _owner The owner whose Drones we are interested in.
    /// @dev This method MUST NEVER be called by smart contract code. Its expensive and returns
    ///  a value that is only supported by web3 calls, not contract-to-contract calls.
    function tokensOfOwner(address _owner) external view returns(uint256[] ownerTokens) {
        uint256 tokenCount = balanceOf(_owner);

        if (tokenCount == 0) {
            // Return an empty array
            return new uint256[](0);
        } else {
            uint256[] memory result = new uint256[](tokenCount);
            uint256 totalDrones = totalSupply();
            uint256 resultIndex = 0;

            // We count on the fact that all drones have IDs starting at 1 and increasing
            // sequentially up to the totalDrone count.
            uint256 droneId;

            for (droneId = 1; droneId <= totalDrones; droneId++) {
                if (droneIndexToOwner[droneId] == _owner) {
                    result[resultIndex] = droneId;
                    resultIndex++;
                }
            }
            return result;
        }
        
    }
    
    /// @dev Adapted from memcpy() by @arachnid (Nick Johnson <arachnid@notdot.net>)
    ///  This method is licenced under the Apache License.
    ///  Ref: https://github.com/Arachnid/solidity-stringutils/blob/2f6ca9accb48ae14c66f1437ec50ed19a0616f78/strings.sol
    function _memcpy(uint _dest, uint _src, uint _len) private pure {
        // Copy word-length chunks while possible
        for (; _len >= 32; _len -= 32) {
            assembly {
                mstore(_dest, mload(_src))
            }
            _dest += 32;
            _src += 32;
        }

        // Copy remaining bytes
        uint256 mask = 256 ** (32 - _len) - 1;
        assembly {
            let srcpart := and(mload(_src), not(mask))
            let destpart := and(mload(_dest), mask)
            mstore(_dest, or(destpart, srcpart))
        }
    }

    /// @dev Adapted from toString(slice) by @arachnid (Nick Johnson <arachnid@notdot.net>)
    ///  This method is licenced under the Apache License.
    ///  Ref: https://github.com/Arachnid/solidity-stringutils/blob/2f6ca9accb48ae14c66f1437ec50ed19a0616f78/strings.sol
    function _toString(bytes32[4] _rawBytes, uint256 _stringLength) private pure returns (string) {
        var outputString = new string(_stringLength);
        uint256 outputPtr;
        uint256 bytesPtr;

        assembly {
            outputPtr := add(outputString, 32)
            bytesPtr := _rawBytes
        }

        _memcpy(outputPtr, bytesPtr, _stringLength);

        return outputString;
    }

    /// @notice Returns a URI pointing to a metadata package for this token conforming to
    ///  ERC-721 (https://github.com/ethereum/EIPs/issues/721)
    /// @param _tokenId The ID number of the Drone whose metadata should be returned.
    function tokenMetadata(uint256 _tokenId, string _preferredTransport) external view returns (string infoUrl) {
        require(erc721Metadata != address(0));
        bytes32[4] memory buffer;
        uint256 count;
        (buffer,count) = erc721Metadata.getMetadata(_tokenId, _preferredTransport);

        return _toString(buffer, count);
    }
}

///@title A facet of EtherStrikeCore that manages Drone Manufacturing
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

    function constructDrone(uint32 _lineId) external whenNotPaused returns(uint256) {
        //Call the AI generation operation
        uint256 newAISource = aIScience.generateNew();

        // Make the new drone!
        address owner = tokManagerAddress;
        uint256 droneID = _createDrone(newAISource, _lineId, owner);
        return droneID;
    }
}

/// @title Handles creating auctions for sale of Drones.
contract SmartDroneAuction is SmartDroneManufacturing {

    /// @dev Sets the reference to the sale auction.
    /// @param _address - Address opf sale contract.
    function setSaleAuctionAddress(address _address) external onlyConManager {
        SaleClockAuction candidateContract = SaleClockAuction(_address);

        //NOTE:verify that a contract is what we expect
        require(candidateContract.isSaleClockAuction());

        //Set the new contract address
        saleAuction = candidateContract;
    }

    // @dev Put a Drone up for auction
    function createSaleAUction(uint256 _droneId, uint256 _startingPrice, uint256 _endingPrice, uint256 _duration) external whenNotPaused {
        // Auction contract checks input sizes
        // If drone is already on any auction, this will throw
        // because it will be owned by the action contract.
        require(_owns(msg.sender,_droneId));
        _approve(_droneId, saleAuction);
        //Sale auction throes if inputs are invalid and clears
        //transfer and sire approval after escrpowing the drone
        saleAuction.createAuction(_droneId,_startingPrice,_endingPrice,_duration,msg.sender);
    }

    /// @dev Transfers the balance of the sale auction contract
    /// to the SmartDroneCore contract. 
    function withdrawAuctionBalances() external onlyManager {
        saleAuction.withdrawBalance();
    }
}

contract SmartDroneMinting is SmartDroneAuction {

    //Constants for manufacturing line auctions
    uint256 public constant MANLINE_STARTING_PRICE = 10 finney;
    uint256 public constant MANLINE_AUCTION_DURATION = 1 days;

    ///@dev Allows us to create promo drones and assign them directly to individuals
    /// @param _sourceAI the seed value for the Drones simple AI
    /// @param _lineId the physical structure of the Drone to be created, any value is accepted
    /// @param _owner the future owner of the created Drone. Default to contract Token Manager
    function createPromoDrone(uint256 _sourceAI, uint32 _lineId, address _owner) external onlyTokManager {
        address droneOwner = _owner;
        if(droneOwner == address(0)){
            droneOwner = tokManagerAddress;
        }
        _createDrone(_sourceAI, _lineId, _owner);
    }

    ///@dev Creates a new SmartDrone with the given AI/Line combo and
    ///creates an auction for it
    function createSmartDroneAuction(uint256 _sourceAI, uint32 _lineId) external onlyTokManager {

        uint256 droneId = _createDrone(_sourceAI,_lineId,address(this));
        _approve(droneId, saleAuction);

        saleAuction.createAuction(droneId,_computeNextAuctionPrice(),0,MANLINE_AUCTION_DURATION,address(this));
    }

    function _computeNextAuctionPrice() internal view returns(uint256) {
        uint256 avePrice = saleAuction.averageManufacturingSalePrice();

        //Sanity check to ensure we don't overflow arithmetic
        require(avePrice == uint256(uint128(avePrice)));

        uint256 nextPrice = avePrice + (avePrice / 2);

        //We never auction for less than starting price
        if(nextPrice < MANLINE_STARTING_PRICE) {
            nextPrice = MANLINE_STARTING_PRICE;
        }

        return nextPrice;
    }
}

//@title EtherStrike: Combat between Smart Drones that learn from their losses, on the Ethereum blockchain.
///@author StreamVade
///@dev The main EtherStrike contract, keeps tracks of drones to prevent rogue AI armageddon.
contract SmartDroneCore is SmartDroneMinting {
    //This is the main EtherStrike contract and the endpoint of the core inheritence. It works in parallel to the SourceAI, Combat and Auction
    //contract collections to create the Blockchain portion of the EtherStrike game.

    //Set in case the core contract is broken and an upgrade is required
    address public newContractAddress;

    ///@notice Creates the main EtherStrike smart contract instance.
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
        newContractaddress = _v2Address;
        ContractUpgrade(_v2Address);
    }

    ///@dev Reject all Ether from  being sent here, unless it's from one of
    // our designated contracts
    function() external payable {
        require(
            msg.sender == address(saleAuction)
        );
    }

    /// @notice Returns all the relevant information about a specific Smart Drone.
    /// @param _id The ID of the Drone of interest.
    function getDrone(uint256 _id) external view returns (uint256 sourceAI, uint256 birthTime, uint256 cooldownEndBlock, uint256 victories, uint256 defeats, uint256 lineId)
    {
        SmartDrone storage drone = smartDrones[_id];
        sourceAI = uint256(drone.sourceAI);
        birthTime = uint256(drone.birthTime);
        cooldownEndBlock = uint256(drone.cooldownEndBlock);
        victories = uint256(drone.victories);
        defeats = uint256(drone.defeats);
        lineId = uint256(drone.lineId);
    }

    //@dev Override unpause so it requires all external contract addresses
    /// to be set before contract can be unpaused. Also, we can't have
    /// newContractAddress set either, because then the contract was upgraded.
    /// @notice This is public rather than external so we can call super.unpause
    /// without using an expensive CALL.
    function unpause() public onlySecManager whenPaused {
        require(saleAuction != address(0));
        require(aIScience != address(0));
        require(newContractAddress == address(0));

        //Actually unpause the contract.
        super.unpause();
    }

    // @dev Allows the Ethereum manager to capture the balance available to the contract.
    function withdrawBalance() external onlyEthManager {
        cfoAddress.send(this.balance;);
    }
}
