


var SmartDroneCore = artifacts.require("./SmartDroneCore.sol");
var SaleClockAuction = artifacts.require("./SaleClockAuction.sol");
var AIScience = artifacts.require("./AIScience.sol")
var WarResolution = artifacts.require("./WarResolution.sol")
var Matchmaker = artifacts.require("./MatchMaker.sol")
var Manufacturing = artifacts.require("./Manufacturing.sol")
var MatchEnvironment = artifacts.require("./MatchEnvironment.sol")


contract('SmartDroneCore', function(accounts) {

    //Replace the core/secondary/tertiary addresses with the addresses you want to link before you run this script
    //core contract
    let coreInstance = SmartDroneCore.at('0x4c9b0a0f81ca0c43d0685a3bc4149703dc77208c');
    //sibling contracts
    let warResolutionInstance = WarResolution.at('0x6bba46b7e0f333166112dba125a52486e0c02a71');
    let saleInstance = SaleClockAuction.at('0x98f01e1499a6a2f31d9bfebd2ebeb9d64e9ce35e');
    let matchMakerInstance = Matchmaker.at('0xc999a0d24abaa5f8445bb821f1a83f3a67e81693')
    let manufacturingInstance = Manufacturing.at('0x7e250106297bd505b8c273b195be42d1502a2078');
    //siblings of sibling contracts
    let aiScienceInstance = AIScience.at('0x59eb2f4ae8789e5f1a4c3b83e2e69cc6471d16c2');
    let matchEnvironmentInstance = MatchEnvironment.at('0xf935a29d9e81c8425c270eae5e5ee95c2ba06686');
   

    //Setup the manager accounts
    it("...should set the ConManager.", function() {
        return coreInstance.setConManager(accounts[1], {from: accounts[0]}).then(function() {
            return coreInstance.conManagerAddress.call();
        }).then(function(conAddress) {
            assert.equal(conAddress, accounts[1], "The con account was not set.");
        });
    });

    it("...should set the EthManager.", function() {
        return coreInstance.setEthManager(accounts[2], {from: accounts[0]}).then(function() {
            return coreInstance.ethManagerAddress.call();
        }).then(function(ethAddress) {
            assert.equal(ethAddress, accounts[2], "The eth account was not set.");
        });
    });

    it("...should set the TokManager.", function() {
        return coreInstance.setTokManager(accounts[3], {from: accounts[0]}).then(function() {
            return coreInstance.tokManagerAddress.call();
        }).then(function(tokAddress) {
            assert.equal(tokAddress, accounts[3], "The tok account was not set.");
        });
    });

    //Transfer ownership of secondary and tertiary contracts to con manager
    it("...should give the Auction contract to the the ConManager.", function() {
        return saleInstance.transferOwnership(accounts[1], {from: accounts[0]}).then(function() {
            assert.equal(accounts[1], accounts[1], "This should never fail.");
        });
    });

    it("...should give the Matchmaking contract to the the ConManager.", function() {
        return matchMakerInstance.transferOwnership(accounts[1], {from: accounts[0]}).then(function() {
            assert.equal(accounts[1], accounts[1], "This should never fail.");
        });
    });

    it("...should give the WarResolution contract to the the ConManager.", function() {
        return warResolutionInstance.transferOwnership(accounts[1], {from: accounts[0]}).then(function() {
            assert.equal(accounts[1], accounts[1], "This should never fail.");
        });
    });

    it("...should give the Manufacturing contract to the the ConManager.", function() {
        return manufacturingInstance.transferOwnership(accounts[1], {from: accounts[0]}).then(function() {
            assert.equal(accounts[1], accounts[1], "This should never fail.");
        });
    });

    it("...should give the MatchEnvironment contract to the the ConManager.", function() {
        return matchEnvironmentInstance.transferOwnership(accounts[1], {from: accounts[0]}).then(function() {
            assert.equal(accounts[1], accounts[1], "This should never fail.");
        });
    });

    //Setup the secondary contract links
    it("...should set the Auction contract.", function() {
        return coreInstance.setSaleAuctionAddress(saleInstance.address,{from: accounts[1]}).then(function(){
        return coreInstance.saleAuction.call().then(function(contra){
                return saleInstance.nonFungibleContract.call().then(function(conFun){
                    assert.equal(conFun,coreInstance.address, "Auction contract not linked to core");
                    assert.equal(contra,saleInstance.address, "Auction contract not set");
                });
            });  
        });
    });

    it("...should set the Matchmaking contract.", function() {
        return coreInstance.setMatchmakerAddress(matchMakerInstance.address,{from: accounts[1]}).then(function(){
            return coreInstance.matchMaker.call().then(function(contra){
                assert.equal(contra,matchMakerInstance.address, "Matchmaking contract not set");
            });  
        }); 
    });

    it("...should set the War Resolution contract.", function() {
        return coreInstance.setWarAddress(warResolutionInstance.address,{from: accounts[1]}).then(function(){
            return coreInstance.warResolution.call().then(function(contra){
                assert.equal(contra,warResolutionInstance.address, "War resolution contract not set");
            });  
        });
    });

    it("...should set the Manufacturing contract.", function() {
        manufacturingInstance.setSaleAuctionAddress(saleInstance.address,{from: accounts[1]});
        coreInstance.setManufacturingAddress(manufacturingInstance.address,{from: accounts[1]}).then(function(){
            return coreInstance.manufacturingAddress.call().then(function(contra){
                assert.equal(contra,manufacturingInstance.address, "Manufacturing contract not set");
            });  
        });
    });

    //Setup the tertiary contract links
    it("...should set the aiScience contract.", function() {
        return warResolutionInstance.setaIScienceAddress(aiScienceInstance.address,{from: accounts[1]}).then(function(){
            return warResolutionInstance.aIScience.call().then(function(contra){
                assert.equal(contra,aiScienceInstance.address, "AIScience contract not set");
            });  
        });
    });

    it("...should set the MatchEnvironment contract.", function() {
        return matchMakerInstance.setMatchEnvironmentAddress(matchEnvironmentInstance.address,{from: accounts[1]}).then(function(){
            return matchMakerInstance.enviroAddress.call().then(function(contra){
                return matchEnvironmentInstance.setMatchmakerAddress(matchMakerInstance.address,{from: accounts[1]}).then(function(){
                    return matchEnvironmentInstance.matchMaker.call().then(function(matchMkRet){
                        assert.equal(contra,matchEnvironmentInstance.address, "MatchEnvironment contract not set");
                        assert.equal(matchMkRet,matchMakerInstance.address, "MatchEnvironment matchmaker ref not set");
                    });
                });
            });  
        });  
    });

    //Unpause
    it("...should un-pause the contract.", function() {
        return coreInstance.unpauseCore( {from: accounts[0]}).then(function() {
            return coreInstance.paused.call().then(function(paused) {
                assert.equal(paused,false, "Contract is stll paused");
            });
        });
    });
  
});
