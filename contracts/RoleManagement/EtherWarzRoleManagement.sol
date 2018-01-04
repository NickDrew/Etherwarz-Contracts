pragma solidity ^0.4.17;

///Some of the below contracts were adapted from those designed for use in the Cryptokitties DAP. Go check it out!  (https://www.cryptokitties.co/)
///Many thanks to Axiom Zen (https://www.axiomzen.co) and the Loom Network (https://loomx.io/) for their excellent work 
///both pushing the boundries of Blockchain DAP development and providing excellent tutorials and learning resources.

/// @title Role management contract for EtherWarz
/// @author StreamVade
/// @dev see the EtherWarzCore contract documentation to understand exactly how this is used.
contract EtherWarzRoleManagement {

    //This contract manages roles that have access to make changes to EtherWarz contracts.
    //SecurityManager:  The Security Manager can reassign roles, alter this contract and unpause the smart contract. 
    //                  It is initially set to the address that created the smart contract in the EtherWarzCore constructor.
    //ContractManager:  The Contract Manager can update core EtherWarz contract facets.
    //EtherManager:     The Ethereum Manager can withdraw funds from EtherWarzCore and its sub-contracts.
    //TokenManager:     The Token Manager can mint new SmartDrone tokens.

    ///@dev Emited when contract is upgraded.
    event ContractUpgrade(address newContract);

    // The addresses of the accounts that can execute actions within each role.
    address public secManagerAddress;
    address public conManagerAddress;
    address public ethManagerAddress;
    address public tokManagerAddress;

    ///@dev Keeps track of whether the contract is paused. When that is true, most actions are blocked.
    bool public paused = false;

    ///@dev Access modifier for SecurityManager-only functionality.
    modifier onlySecManager() {
        require(msg.sender == secManagerAddress);
        _;
    }

    ///@dev Access modifier for ContractManager-only functionality.
    modifier onlyConManager() {
        require(msg.sender == conManagerAddress);
        _;
    }

    ///@dev Access modifier for EtherManager-only functionality.
    modifier onlyEthManager() {
        require(msg.sender == ethManagerAddress);
        _;
    }

    ///@dev Access modifier for TokenManager-only functionality.
    modifier onlyTokManager(){
        require(msg.sender == tokManagerAddress);
        _;
    }

    ///@dev Access modifier for Manager-only functionality.
    modifier onlyManager(){
        require(msg.sender==secManagerAddress||msg.sender==conManagerAddress||msg.sender==ethManagerAddress||msg.sender==tokManagerAddress);
        _;
    }

    ///@dev Assigns a new address to act as the Security Manager. Only available to the current Security Manager.
    ///@param _newSecManager The address of the new Security Manager.
    function setSecManager(address _newSecManager) external onlySecManager {
        require(_newSecManager != address(0));

        secManagerAddress = _newSecManager;
    }
  
    ///@dev Assigns a new address to act as the Contract Manager. Only available to the current Security Manager.
    ///@param _newConManager The address of the new Contract Manager.
    function setConManager(address _newConManager) external onlySecManager {
        require(_newConManager != address(0));
        conManagerAddress = _newConManager;
    }

    ///@dev Assigns a new address to act as the Ethereum Manager. Only available to the current Security Manager.
    ///@param _newEthManager The address of the new Ethereum Manager.
    function setEthManager(address _newEthManager) external onlySecManager {
        require(_newEthManager != address(0));
        ethManagerAddress = _newEthManager;
    }

    ///@dev Assigns a new address to act as the Token Manager. Only available to the current Security Manager.
    ///@param _newTokManager The address of the new Token Manager.
    function setTokManager(address _newTokManager) external onlySecManager {
        require(_newTokManager != address(0));
        tokManagerAddress = _newTokManager;
    }

    /*** Pausable functionality adapted from OpenZeppelin ***/

    /// @dev Modifier to allow actions only when the contract IS NOT paused
    modifier whenNotPaused() {
        require(!paused);
        _;
    }

    /// @dev Modifier to allow actions only when the contract IS paused
    modifier whenPaused {
        require(paused);
        _;
    }

    /// @dev Called by any Manager role to pause the contract. Used only when
    ///  a bug or exploit is detected and we need to limit damage.
    function pause() external onlyManager whenNotPaused {
        paused = true;
    }

    /// @dev Unpauses the smart contract. Can only be called by the Security Manager, since
    ///  one reason we may pause the contract is when other accounts are
    ///  compromised.
    /// @notice This is public rather than external so it can be called by
    ///  derived contracts.
    function unpause() public onlySecManager whenPaused {
        // can't unpause if contract was upgraded
        paused = false;
    }
}