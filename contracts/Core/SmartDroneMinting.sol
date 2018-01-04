pragma solidity ^0.4.17;

import 'contracts/Core/SmartDroneAuction.sol';

contract SmartDroneMinting is SmartDroneAuction {

    //Constants for manufacturing line auctions
    uint256 public constant MANLINE_STARTING_PRICE = 10 finney;
    uint256 public constant MANLINE_AUCTION_DURATION = 1 days;

    ///@dev Allows us to create promo drones and assign them directly to individuals
    /// @param _sourceAI the seed value for the Drones simple AI
    /// @param _lineId the physical structure of the Drone to be created, any value is accepted
    /// @param _owner the future owner of the created Drone. Default to contract Token Manager
    function createPromoDrone(bytes32 _sourceAI, bytes32 _lineId, address _owner) external onlyTokManager {
        address droneOwner = _owner;
        if(droneOwner == address(0)){
            droneOwner = tokManagerAddress;
        }
        _createDrone(_sourceAI, _lineId, _owner);
    }

    ///@dev Creates a new SmartDrone with the given AI/Line combo and
    ///creates an auction for it
    function createSmartDroneAuction(bytes32 _sourceAI, bytes32 _lineId) external onlyTokManager {

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