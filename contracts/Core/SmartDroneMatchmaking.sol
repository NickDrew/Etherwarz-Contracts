pragma solidity ^0.4.17;


import 'contracts/Tokens/ERC721Match.sol';
import 'contracts/Matchmaker/Matchmaker.sol';
import 'contracts/Core/SmartDroneWar.sol';


//@title SmartDroneMatchmaker handles Drone interactions with matchmaking
///@author StreamVade
contract SmartDroneMatchMaking is SmartDroneWar {

     ///@dev The address of the sibling contract that is used to control AI
    MatchMaker public matchMaker;

    ///@dev Update the address of the aMAtchMaker contract. Can only be called by the Contract Manager.
    ///@param _address An address of a aIScience contract instance to be used from this point forward.
    function setMatchmakerAddress(address _address) external onlyConManager {

        MatchMaker candidateContract = MatchMaker(_address);

        // NOTE: verify that a contract is what we expect
        require(candidateContract.isMatchMaker());

        // Set the new contract address
        matchMaker = candidateContract; 
    }

    // @dev Processes whatever logic is associated with a match and produces a winner and a looser
    function processMatch(uint256 _makerTokenId, uint256 _takerTokenId, uint32 _matchDetails ) external returns (address, address)
    {
        uint8 winner;
        uint16 primeAtt;
        uint64 looserAI;
        address winnerAdd;
        address looserAdd;
        (winner,primeAtt,looserAI)= warResolution.War(smartDrones[_makerTokenId].sourceAI,smartDrones[_makerTokenId].lineId,smartDrones[_takerTokenId].sourceAI,smartDrones[_takerTokenId].lineId,_matchDetails);
        
        if(winner==1)
        {
            smartDrones[_takerTokenId].sourceAI = looserAI;
            smartDrones[_takerTokenId].defeats++;
            smartDrones[_makerTokenId].victories++;
            winnerAdd = droneIndexToOwner[_makerTokenId];
            looserAdd = droneIndexToOwner[_takerTokenId];
        }
        else
        {
            
            smartDrones[_makerTokenId].sourceAI = looserAI;
            smartDrones[_makerTokenId].defeats++;
            smartDrones[_takerTokenId].victories++;
            winnerAdd = droneIndexToOwner[_takerTokenId];
            looserAdd = droneIndexToOwner[_makerTokenId];
        }
        
        return (winnerAdd, looserAdd);
    }

    // @dev Checks to ensure a token isn't up for sale, or in any other state that might make it invalid for matchmaking
    function canMatch(uint256 _makerTokenId) external  returns(bool)
    {
        //if a done has a deligated approval for transfer setup (ie non address(0), then
        //it is up for sale or already in a match, which blocks it's entry int a new match.
        return (droneIndexToApproved[_makerTokenId] == address(0));
    }

    // @dev Locks down a token once it has been used to make a match, to prevent it entering invalid states
    function intoMatch(uint256 _makerTokenId) external 
    {
        droneIndexToApproved[_makerTokenId] = matchMaker;
    }

    // @dev unlocks a token once it is no longer the maker in a match
    function outofMatch(uint256 _makerTokenId) external 
    {
        require(droneIndexToApproved[_makerTokenId] == msg.sender);
        droneIndexToApproved[_makerTokenId] = address(0);
    }
    
    
}