pragma solidity ^0.4.17;

import "contracts/Tokens/ERC721.sol";

/// @title Extenstion of ERC721 that allows matchmaking for NFT's
contract ERC721Match is ERC721 {
    
    
    // Required methods
    function processMatch(uint256 makerId, uint256 takerId, uint32 matchDetails ) external pure returns (address, address)
    {
    
        address winner;
        address looser;
        return (winner, looser);
    }

}