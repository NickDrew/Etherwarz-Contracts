pragma solidity ^0.4.17;

import "contracts/Matchmaker/MatchmakerBase.sol";
import 'contracts/zeppelin/ownership/Ownable.sol';
import 'contracts/Matchmaker/MatchEnvironmentInterface.sol';

contract MatchMaker is Pausable, MatchmakerBase {
    

    function MatchMaker( address _nftMatchAddress, uint256 _cut) public {
        require(_cut <= 10000);
        runnersCut = _cut;

        ERC721Match candidateContract = ERC721Match(_nftMatchAddress);

        matchableNonFungibleContract = candidateContract;
    }

    function withdrawBalance() external {
        address nftAddress = address(matchableNonFungibleContract);

        require(
            msg.sender == owner ||
            msg.sender == nftAddress
        );
        // We are using this boolean method to make sure that even if one fails it will still work
        bool res = nftAddress.send(this.balance-escrowAmount);
        res = res; //To stop warnings about unused variables in some IDE's.

    }

    /// @dev Makes a new match
    function makeMatch(uint256 _tokenId, uint128 _matchCash, uint32 _matchDetails, address _matcher) external payable whenNotPaused {
        require(msg.sender == enviroAddress);
        require(matchableNonFungibleContract.canMatch(_tokenId));
        require(msg.value >= _matchCash);
        matchableNonFungibleContract.intoMatch(_tokenId);
        Match memory _match = Match(
            _matcher,
            _matchCash,
            _matchDetails,
            uint64(now)
        );
        _addMatch(_tokenId,_match);
        escrowAmount += _matchCash;
    }

    /// @dev Take an existing match
    function takeMatch(uint256 _takerTokenId, uint256 _makerTokenId) external payable whenNotPaused {
        require(_owns(msg.sender,_takerTokenId));
        require(msg.value >= tokenIdtoMatch[_makerTokenId].matchCash);
        uint256 tstval = tokenIdtoMatch[_makerTokenId].matchCash;
        escrowAmount += tokenIdtoMatch[_makerTokenId].matchCash;
        _takeMatch(_makerTokenId, _takerTokenId, tokenIdtoMatch[_makerTokenId].matchCash);
        matchableNonFungibleContract.outofMatch(_makerTokenId);
        escrowAmount -= (tstval *2);
    }
    
    /// @dev Cancel an existing match
    function cancelMatch(uint256 _tokenId) external {
        Match storage _match = tokenIdtoMatch[_tokenId];
        uint128 matchCash = _match.matchCash;
        require(_isInMatch(_match));
        address matchMaker = _match.maker;
        require(msg.sender == matchMaker);
        _cancelMatch(_tokenId);
        matchableNonFungibleContract.outofMatch(_tokenId);
        matchMaker.transfer(matchCash);
        escrowAmount -= matchCash;
    }

    /// @dev Cancels a match when the contract is paused
    /// Only available to the contract owner and all matchcash 
    /// is returned to the NFTs owner.
    function cancelMatchWhenPaused (uint256 _tokenId) whenPaused onlyOwner external {
        Match storage _match = tokenIdtoMatch[_tokenId];
        require(_isInMatch(_match));
        uint128 matchCash = _match.matchCash;
        _cancelMatch(_tokenId);
        matchableNonFungibleContract.outofMatch(_tokenId);
        escrowAmount -= matchCash;
    }

    /// @dev Returns match info for an NFT in a match
    function getMatch(uint256 _tokenId) external view returns(address maker, uint128 matchCash, uint64 startedAt)
    {
       
        Match storage _match = tokenIdtoMatch[_tokenId];
        require(_isInMatch(_match));
       
        return(
            _match.maker,
            _match.matchCash,
            _match.startedAt
        );
    }

    function isMatchMaker() external pure returns(bool)
    {
        return true;
    }
    
    ///@dev The address of the sibling contract that is used to control environment creation
    address public enviroAddress;

    ///@dev Update the address of the aMAtchMaker contract. Can only be called by the Contract Manager.
      function setMatchEnvironmentAddress(address _address) external onlyOwner {

        MatchEnvironmentInterface candidateContract = MatchEnvironmentInterface(_address);

        // NOTE: verify that a contract is what we expect
        require(candidateContract.isEnvironment());

        // Set the new contract address
        enviroAddress = _address; 
    }

}