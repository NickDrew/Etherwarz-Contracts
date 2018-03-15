pragma solidity ^0.4.17;

import "contracts/War/WarInterface.sol";
import "contracts/AIScience/AIScience.sol";

/// @title No, you don't get to see this :P
contract WarResolution is WarInterface {
   
    function War(uint64 _p1AI, uint128 _p1Line, uint64 _p2AI, uint128 _p2Line, uint32 _enviroment) external returns(uint8, uint16, uint64) {
       uint8 winner;
       uint16 primeAtt;
       uint64 newAI;
       primeAtt = uint16(extract32(_enviroment,2)*2);
       
       if(scoreCalc(_p1AI,_p1Line,_enviroment) > scoreCalc(_p2AI,_p2Line,_enviroment))
       {
            winner=1;
            newAI = aIScience.learnFromLoss(_p2AI, primeAtt);
       }
       else
       {
            winner=2;
            newAI = aIScience.learnFromLoss(_p1AI, primeAtt);
       }
        
        return(winner,primeAtt,newAI);
    }
    
    function scoreCalc(uint64 _AI, uint128 _Line, uint32 _enviroment) internal pure returns(uint32)
    {
        return uint32((extract64(_AI,16)+ extract128(_Line,5))*extract32(_enviroment,8)+
                                (extract64(_AI,14)+ extract128(_Line,7))*extract32(_enviroment,7)+
                                (extract64(_AI,12)+ extract128(_Line,3))*extract32(_enviroment,6)+
                                (extract64(_AI,10)+ extract128(_Line,7))*extract32(_enviroment,5)+
                                (extract64(_AI,8)+ extract128(_Line,5))*extract32(_enviroment,4)+
                                (extract64(_AI,6)+ extract128(_Line,3))*extract32(_enviroment,3));
    }
    
    function extract32(uint32 _looser, uint16 position) internal pure returns (uint32)
    {
        return ((_looser % (10**(position))) -(_looser % (10**(position-1))))/(10**(position-1)) ;
    }
    
    function extract64(uint64 _looser, uint64 position) internal pure returns (uint64)
    {
        return ((_looser % (10**(position))) -(_looser % (10**(position-2))))/(10**(position-2)) ;
    }
    
    function extract128(uint128 _looser, uint128 position) internal pure returns (uint128)
    {
        return ((_looser % (10**(position))) -(_looser % (10**(position-2))))/(10**(position-2)) ;
    }
    
    function tester(uint64 _p1AI, uint128 _p1Line,uint32 _enviroment) internal  pure returns(uint)
    {
        return  scoreCalc(_p1AI,_p1Line,_enviroment);
    }
    
    ///@dev The address of the sibling contract that is used to control AI
    AIScience public aIScience;

    ///@dev Update the address of the aIScience contract. Can only be called by the Contract Manager.
    ///@param _address An address of a aIScience contract instance to be used from this point forward.
    function setaIScienceAddress(address _address) external {

        AIScience candidateContract = AIScience(_address);

        // NOTE: verify that a contract is what we expect
        require(candidateContract.isAIScience());

        // Set the new contract address
        aIScience = candidateContract; 
    }


}