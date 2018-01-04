pragma solidity ^0.4.17;

/// @title No, you don't get to see this :P
contract AIScienceInterface {
    ///@dev simply a boolean to indicate this is the contract we expect to be
    function isAIScience() public pure returns (bool) {
        return true;
    }

    function generateNew() public pure returns (bytes32) {
       bytes32 generatedAiSource = "0";
       
       return generatedAiSource; 
    }
}