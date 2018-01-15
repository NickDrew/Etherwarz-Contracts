pragma solidity ^0.4.17;

import "contracts/Tokens/ERC721.sol";

/// @title Extenstion of ERC721 that allows matchmaking for NFT's
contract ERC721Match is ERC721 {
    
    // Required methods
    // @dev Processes whatever logic is associated with a match and produces a winner and a looser
    function processMatch(uint256 _makerTokenId, uint256 _takerTokenId, uint32 _matchDetails ) external returns (address, address)
    {
        address winner;
        address looser;
        return (winner, looser);
    }

    // @dev Checks to ensure a token isn't up for sale, or in any other state that might make it invalid for matchmaking
    function canMatch(uint256 _makerTokenId) external  returns(bool)
    {

        return true;
    }

    // @dev Locks down a token once it has been used to make a match, to prevent it entering invalid states
    function intoMatch(uint256 _makerTokenId) external 
    {

    }

    // @dev unlocks a token once it is no longer the maker in a match
    function outofMatch(uint256 _makerTokenId) external 
    {

    }

}