pragma solidity ^0.4.17;

import 'contracts/AIScience/AIScienceInterface.sol';

/// @title The logic that allows looser to learn from a fight
/// @dev DO NOT PUBLISH THIS WHEN MAKING THE CODE AVAILABLE

contract AIScience is AIScienceInterface {
    /// @param _AI The AI about to be trained
    /// @param _primaryAttribute The position of the attribute that decided the winner by the most significant amount.

     function learnFromLoss(uint64 _AI, uint64 _primaryAttribute) external returns(uint64) {
        //get the memory value
        uint64 memVal = extract(_AI,4);
        //get the primary value
        uint64 primVal = extract(_AI,_primaryAttribute);
        //if primary value is already at memory max, exit function
        if(primVal >= memVal)
        {
            return _AI;
        }
        else
        {
            //get the multitasking value
            uint64 mulVal = extract(_AI,2);
            //increment primary value
            uint64 newAI = learn(_AI,_primaryAttribute);
            primVal +=1;
            //if primary value is now at or below multitasking value, exit the function
            if(primVal <= mulVal)
            {
                return _primaryAttribute;
            }
            else
            {
                //get the antagonistic position
                uint64 antagPos;
                if(_primaryAttribute%4 == 0)
                {
                    antagPos = _primaryAttribute - 2;
                }
                else
                {
                    antagPos = _primaryAttribute + 2;
                }
                //get the antagnoistic value
                uint64 antagVal = extract(newAI,antagPos);
                //if antagnoistic value is above 0, reduce the antagnoistic value
                if(antagVal > 0)
                {
                    newAI = forget(newAI,antagPos);
                }
                return newAI;
            }
            
            
        }
        
    }
    
    function learn(uint64 _looser, uint64 position) internal returns (uint64)
    {
        return uint64(_looser + (10**(position-2)));
    }
    
    function forget(uint64 _looser, uint64 position) internal returns (uint64)
    {
        return uint64(_looser - (10**(position-2)));
    }
    
    function extract(uint64 _looser, uint64 position) internal returns (uint64)
    {
        return uint64((_looser % (10**(position))) -(_looser % (10**(position-2))))/(10**(position-2)) ;
    }
}