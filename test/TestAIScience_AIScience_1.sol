pragma solidity ^0.4.17;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "contracts/AIScience/AIScience.sol";
import "contracts/AIScience/AIScienceInterface.sol";

contract TestAIScience_AIScience_1 {

  AIScience aIScience;

 function TestAIScience_AIScience_learnFromLoss_1() {
    
    aIScience = new AIScience();

    Assert.equal(uint(aIScience.learnFromLoss(2525252525252525,6)),uint(2525252525252525), "It should be the same");

  }

  function TestAIScience_AIScience_learnFromLoss_2() {
  
    Assert.equal(uint(aIScience.learnFromLoss(2525252525255025,6)),uint(2525252524262525), "It should be the same");

  }

}