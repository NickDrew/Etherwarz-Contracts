pragma solidity ^0.4.17;


import 'contracts/zeppelin/ownership/Ownable.sol';
import 'contracts/Auctions/SaleClockAuction.sol';
import 'contracts/Tokens/ERC721Match.sol';
import 'contracts/Core/SmartDroneMinting.sol';
import 'contracts/Manufacturing/ManufacturingInterface.sol';


contract Manufacturing is Pausable, ManufacturingInterface {
    //Constants for manufacturing line auctions
    uint256 public constant MANLINE_STARTING_PRICE = 10 finney;
    uint256 public constant MANLINE_AUCTION_DURATION = 1 days;
    SaleClockAuction public saleAuction;
    SmartDroneMinting public smartDroneContract;
    

  function Manufacturing( address _smartDroneAddress ) public {
        
    SmartDroneMinting candidateContract = SmartDroneMinting(_smartDroneAddress);

    smartDroneContract = candidateContract;
  }
 
  function manufacturePromoDrone (uint64 _sourceAI, uint128 _lineId, address _owner) external onlyOwner{
      smartDroneContract.constructDrone(_sourceAI, _lineId , _owner);
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

    function setSaleAuctionAddress(address _address) external onlyOwner {
        SaleClockAuction candidateContract = SaleClockAuction(_address);

        //NOTE:verify that a contract is what we expect
        require(candidateContract.isSaleClockAuction());

        //Set the new contract address
        saleAuction = candidateContract;
    }
}