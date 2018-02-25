pragma solidity ^0.4.17;

import 'contracts/Tokens/ERC721Match.sol';
import 'contracts/Core/SmartDroneBase.sol';
import 'contracts/Tokens/ERC721Metadata.sol';

///@title Manages Drone ownership. Compliant with the draft version of ERC-721.
///@author Streamvade
///@dev See the EtherWarzCore documentation to understand how the various contract facets are arranged.
contract SmartDroneOwnership is SmartDroneBase, ERC721Match {
    
    ///@notice Name and symbol of the non fungible token, as defined in ERC721
    string public constant name = "SmartDrones";
    string public constant symbol = "SD";

    // The contract that will return kitty metadata
    ERC721Metadata public erc721Metadata;


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
        return smartDrones.length;
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