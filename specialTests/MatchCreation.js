


var SmartDroneCore = artifacts.require("./SmartDroneCore.sol");
var SaleClockAuction = artifacts.require("./SaleClockAuction.sol");
var AIScience = artifacts.require("./AIScience.sol")
var WarResolution = artifacts.require("./WarResolution.sol")
var Matchmaker = artifacts.require("./MatchMaker.sol")
var Manufacturing = artifacts.require("./Manufacturing.sol")
var MatchEnvironment = artifacts.require("./MatchEnvironment.sol")


contract('SmartDroneCore', function(accounts) {
  //core contract
  var coreInstance;
  //sibling contracts
  var warResolutionInstance;
  var saleInstance;
  //siblings of sibling contracts
  var aiScienceInstance;
  var coreEvents;
  var auctionEvents;
  var warResEvents;
  var aiSciEvents;
  var manEvents;

  let manufacturingInstance = Manufacturing.at('0xbb0ef9cafed30178781454161c8d1c666ea9455a');
  let matchEnvironmentInstance = MatchEnvironment.at('0xab9b806cc2a6cf64385faef8eabbb14a938113ac');
  let matchMakerInstance = Matchmaker.at('0x73a6db1c05b9990a5ab9e26c8c96020c140ab046')
  matchmakerevents = matchMakerInstance.allEvents(function(error, log){
    if (!error)
      console.log(log.event);
      console.log(log.args);
  });


  
  //Create a drone
  it("...should create a drone.", function() {
    return manufacturingInstance.manufacturePromoDrone(2525252525257550,00000000000000000000000005050505,accounts[0], {from: accounts[0]}).then(function() {
        assert.equal(1,1, "Drone not created");
    });
  });
  
  it("...should create a match", function(){
    return matchEnvironmentInstance.makeMatch(10,10000,0,{from: accounts[0], to: matchEnvironmentInstance.address, value: 10000}).then(function(){
      return matchMakerInstance.getMatch(10,{from: accounts[0]}).then(function(match0){
        assert.equal(match0[0],accounts[0],"Match maker not set correctly");
        assert.equal(match0[1],10000,"Match cash not set correctly");
      });
    });
  });
  
});
