pragma solidity ^0.4.17;

import 'contracts/zeppelin/ownership/Ownable.sol';
import 'contracts/Matchmaker/Matchmaker.sol';
import 'contracts/Matchmaker/MatchEnvironmentInterface.sol';

/// @title Matchmaker Core
/// @dev Contains models, variables and internal methods for the matchmaker.
contract MatchmakerEnvironment is  MatchEnvironmentInterface, Ownable
{
    function MatchmakerEnvironment(address _nftAddress) public {
       
        ERC721Match candidateContract = ERC721Match(_nftAddress);
        
        matchableNonFungibleContract = candidateContract;
    }

    MatchMaker public matchMaker;

    function setMatchmakerAddress(address _address) external onlyOwner {
        MatchMaker candidateContract = MatchMaker(_address);
        // NOTE: verify that a contract is what we expect
        require(candidateContract.isMatchMaker());
        // Set the new contract address
        matchMaker = candidateContract; 
    }

    // Reference to contract tracking NFT ownership
    ERC721Match public matchableNonFungibleContract;

    // Map from Makers token ID to their corresponding match.
    mapping (uint256=> uint32) envDetailOptions;

    /// @dev Returns true if the claimant owns the token.
    function _owns(address _claimant, uint256 _tokenId) internal view returns(bool) {
        return(matchableNonFungibleContract.ownerOf(_tokenId)== _claimant);
    }
   
    function makeMatch(uint256 _tokenId, uint128 _matchCash, uint256 _envDetails, address _matcher) external payable {
        require(_owns(msg.sender, _tokenId));
        matchMaker.makeMatch.value(msg.value)(_tokenId,_matchCash,envDetailOptions[_envDetails],_matcher );
    }

    function makeEnvironment(uint256 _envID, uint32 _envDetails) external onlyOwner
    {
        envDetailOptions[_envID] = _envDetails;
    }

    function getEnvironment(uint256 _envID) external view returns(uint32)
    {
       return envDetailOptions[_envID];
    }

}