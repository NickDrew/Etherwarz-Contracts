pragma solidity ^0.4.17;

import 'contracts/Core/SmartDroneManufacturing.sol';
import 'contracts/RoleManagement/EtherWarzRoleManagement.sol';

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
