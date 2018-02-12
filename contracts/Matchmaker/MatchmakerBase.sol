pragma solidity ^0.4.17;

import 'contracts/zeppelin/ownership/Ownable.sol';
import 'contracts/Tokens/ERC721Match.sol';

/// @title Matchmaker Core
/// @dev Contains models, variables and internal methods for the matchmaker.
contract MatchmakerBase{

    //Represents a match for an NFT
    struct Match {
        //Owner of the initiating NFT
        address maker;
        //Value (in wei) being put up by the maker as potential winnings. 
        //Takers must equal this contribution (on top of gas costs) to 
        //take on a match.
        uint128 matchCash;
        //Value that can be used to store encoded match details
        uint32 matchDetails;
        //Time when match was put up by the maker.
        // NOTE: 0 if this match has been taken.
        uint64 startedAt;
    }

    // Reference to contract tracking NFT ownership
    ERC721Match public matchableNonFungibleContract;

    // Cut runner takes on a match, measured in basis points (1/100 of a percent).
    // Values 0-10,000 map to 0%-100%
    uint256 public runnersCut;

    // The amount held in escrow for payout to match winners.
    uint256 internal escrowAmount;

    // Map from Makers token ID to their corresponding match.
    mapping (uint256=> Match) tokenIdtoMatch;

    event MatchCreated(uint256 tokenId, uint256 matchCash, uint32 matchDetails, uint64 startedAt);
    event MatchTaken(uint256 tokenId, uint256 winnerCash, uint256 winnerID, uint256 looserID);
    event MatchCancelled(uint256 tokenID);
    /// @dev Returns true if the claimant owns the token.
    function _owns(address _claimant, uint256 _tokenId) internal view returns(bool) {
        return(matchableNonFungibleContract.ownerOf(_tokenId)== _claimant);
    }


    /// @dev Adds a match to the list of open matches. Also fires the MatchCreated event.
    function _addMatch(uint256 _tokenId, Match _match) internal {

        tokenIdtoMatch[_tokenId] = _match;

        MatchCreated(
            uint256(_tokenId),
            uint256(_match.matchCash),
            uint32(_match.matchDetails),
            uint64(_match.startedAt)
        );

    }

    function _takeMatch(uint256 _makerTokenId, uint256 _takerTokenId, uint256 _cashAmount) internal
    {
        Match storage _match = tokenIdtoMatch[_makerTokenId];
        require(_isInMatch(_match));
        require(_cashAmount >= _match.matchCash);
        address makerAddress = _match.maker;
        address winner;
        address looser;
        uint256 winnerCash = 0;
        (winner, looser) = matchableNonFungibleContract.processMatch(_makerTokenId, _takerTokenId,_match.matchDetails);
        _removeMatch(_makerTokenId);

        if((_cashAmount+_match.matchCash)>0)
        {
            uint256 matchRunnerCut = _computeCut((_cashAmount+_match.matchCash));
            winnerCash = _cashAmount+_match.matchCash - matchRunnerCut;

            //guarded against re-entry attack by already having called _removeMatch.
            winner.transfer(winnerCash);

        }
        if(winner == makerAddress)
        {
            MatchTaken(_makerTokenId, winnerCash, _makerTokenId, _takerTokenId );
        }
        else
        {
            MatchTaken(_makerTokenId, winnerCash, _takerTokenId, _makerTokenId);
        }
        
        
    }

    function _cancelMatch(uint256 _tokenId) internal {
        _removeMatch(_tokenId);
        MatchCancelled(_tokenId);
    }

    /// @dev Removes a match from the list of open matches.
    function _removeMatch(uint256 _tokenId) internal {
        delete tokenIdtoMatch[_tokenId];
    }

    /// returns true if the NFT is in a match
    function _isInMatch(Match storage _match) internal view returns (bool) {
        return (_match.startedAt > 0);
    }
    
   /// @dev Computes winners's cut of a match.
    function _computeCut(uint256 _matchCash) internal view returns (uint256) {
        return _matchCash * runnersCut / 10000;
    }
}