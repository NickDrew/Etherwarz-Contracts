


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
  var manufacturingInstance;
  var saleInstance;
  var matchMakerInstance;
  //siblings of sibling contracts
  var aiScienceInstance;
  var matchEnvironmentInstance;
  var coreEvents;
  var auctionEvents;
  var warResEvents;
  var aiSciEvents;
  var manEvents;
  //Setup the core contract and managers
  it("...should set the EthManager.", function() {
    return SmartDroneCore.new().then(function(instance) {
      coreInstance = instance;

     /*coreEvents = coreInstance.allEvents(function(error, log){
        if (!error)
          console.log(log.event);
          console.log(log.args);
      });*/
      console.log("The core address!");
      console.log(coreInstance.address);
      return coreInstance.setEthManager(accounts[2], {from: accounts[0]});
    }).then(function() {
      return coreInstance.ethManagerAddress.call();
    }).then(function(ethAddress) {
      assert.equal(ethAddress, accounts[2], "The account was not set.");
    });
  });

  it("...should set the ConManager.", function() {
      return coreInstance.setConManager(accounts[0], {from: accounts[0]}).then(function() {
      return coreInstance.conManagerAddress.call();
    }).then(function(ethAddress) {
      assert.equal(ethAddress, accounts[0], "The account was not set.");
    });
  });

  it("...should set the TokManager.", function() {
      return coreInstance.setTokManager(accounts[0], {from: accounts[0]}).then(function() {
      return coreInstance.tokManagerAddress.call();
    }).then(function(ethAddress) {
      assert.equal(ethAddress, accounts[0], "The account was not set.");
    });
  });
  
  //Setup the sibling contracts
  it("...should set the Auction contract.", function() {
       return SaleClockAuction.new(coreInstance.address,9000,{from: accounts[0]}).then(function(insta){
        saleInstance = insta;
        /*auctionEvents = saleInstance.allEvents(function(error, log){
          if (!error)
            console.log(log.event);
          console.log(log.args);
        });*/
        console.log("The sales address");
        console.log(saleInstance.address);
         coreInstance.setSaleAuctionAddress(saleInstance.address,{from: accounts[0]}).then(function(){
          return coreInstance.saleAuction.call().then(function(contra){
            return saleInstance.nonFungibleContract.call().then(function(conFun){
              assert.equal(conFun,coreInstance.address, "Auction contract not linked to core");
              assert.equal(contra,saleInstance.address, "Auction contract not set");
            });
            
          });  
        });
      });
    });
 
  it("...should set the Matchmaking contract.", function() {
      return  Matchmaker.new(coreInstance.address,9000,{from: accounts[0]}).then(function(retInst){
        matchMakerInstance = retInst;
        console.log("The matchmaker address!");
        console.log(matchMakerInstance.address);
        /*matchMakerEvents = matchMakerInstance.allEvents(function(error, log){
          if (!error)
          console.log(log.event);
          console.log(log.args);
        });*/
        coreInstance.setMatchmakerAddress(matchMakerInstance.address,{from: accounts[0]}).then(function(){
         return coreInstance.matchMaker.call().then(function(contra){
           assert.equal(contra,matchMakerInstance.address, "Matchmaking contract not set");
         });  
       });

      });
      
    });
  
    it("...should set the War Resolution contract.", function() {
      return WarResolution.deployed().then(function(warinst){
        warResolutionInstance = warinst;
       /* warResEvents = warinst.allEvents(function(error, log){
          if (!error)
            console.log(log.event);
            console.log(log.args);
        });*/
        
        coreInstance.setWarAddress(warResolutionInstance.address,{from: accounts[0]}).then(function(){
         return coreInstance.warResolution.call().then(function(contra){
           assert.equal(contra,warResolutionInstance.address, "War resolution contract not set");
         });  
       });
     });
   });

   it("...should set the Manufacturing contract.", function() {
    return Manufacturing.new(coreInstance.address,{from: accounts[0]}).then(function(manInst){
      manufacturingInstance = manInst;
      /*manEvents = manInst.allEvents(function(error, log){
          if (!error)
            console.log(log.event);
            console.log(log.args);
        });*/
        console.log("Manufacturing Address!")
        console.log(manufacturingInstance.address);
      manufacturingInstance.setSaleAuctionAddress(saleInstance.address,{from: accounts[0]});
      coreInstance.setManufacturingAddress(manufacturingInstance.address,{from: accounts[0]}).then(function(){
       return coreInstance.manufacturingAddress.call().then(function(contra){
         assert.equal(contra,manufacturingInstance.address, "Manufacturing contract not set");
       });  
     });
    }); 
   });

   //Setup the siblings of sibling contracts
   it("...should set the aiScience contract.", function() {
    return AIScience.new({from: accounts[0]}).then(function(aiInst){
      aiScienceInstance = aiInst;
     /* aiSciEvents = aiInst.allEvents(function(error, log){
        if (!error)
          console.log(log.event);
          console.log(log.args);
      });*/
      warResolutionInstance.setaIScienceAddress(aiScienceInstance.address,{from: accounts[0]}).then(function(){
       return warResolutionInstance.aIScience.call().then(function(contra){
         assert.equal(contra,aiScienceInstance.address, "AIScience contract not set");
       });  
     });
    }); 
   });

   it("...should set the MatchEnvironment contract.", function() {
    return MatchEnvironment.new(coreInstance.address,{from: accounts[0]}).then(function(envInst){
      matchEnvironmentInstance = envInst;
      /*matchEnvEvents = matchEnvironmentInstance.allEvents(function(error, log){
        if (!error)
          console.log(log.event);
          console.log(log.args);
      });*/
      console.log("The matchenvironment address!");
      console.log(matchEnvironmentInstance.address);
      matchMakerInstance.setMatchEnvironmentAddress(matchEnvironmentInstance.address,{from: accounts[0]}).then(function(){
       return matchMakerInstance.enviroAddress.call().then(function(contra){
         return matchEnvironmentInstance.setMatchmakerAddress(matchMakerInstance.address,{from: accounts[0]}).then(function(){
           return matchEnvironmentInstance.matchMaker.call().then(function(matchMkRet){
            assert.equal(contra,matchEnvironmentInstance.address, "MatchEnvironment contract not set");
            assert.equal(matchMkRet,matchMakerInstance.address, "MatchEnvironment matchmaker ref not set");
           });
         });
       });  
     });
    }); 
   });

  //Test unpausing and pausing
  it("...should un-pause the contract.", function() {
    return coreInstance.unpauseCore( {from: accounts[0]}).then(function() {
    return coreInstance.paused.call().then(function(paused) {
        assert.equal(paused,false, "Contract is stll paused");
      });
  });
  });

 
  it("...should pause the contract.", function() {
      return coreInstance.pause( {from: accounts[0]}).then(function() {
      return coreInstance.paused.call().then(function(paused) {
        assert.equal(paused,true, "Contract is stll unpaused");
      });
    });
  });

  //Unpausing again to allow further processing
  it("...should un-pause the contract.", function() {
    return coreInstance.unpauseCore( {from: accounts[0]}).then(function() {
    return coreInstance.paused.call().then(function(paused) {
        assert.equal(paused,false, "Contract is stll paused");
      });
  });
  });


  //Create a drone
  it("...should create a drone.", function() {
    return manufacturingInstance.manufacturePromoDrone(2525252525257550,00000000000000000000000005050505,accounts[0], {from: accounts[0]}).then(function() {
      return coreInstance.balanceOf(accounts[0]).then(function(balance1) {
        assert.equal(balance1,1, "Drone not created");
      });
    });
  });

 //Make sure the drones data has been setup correctly
  it("...should get drone data.", function(){
    return coreInstance.getDrone(0,{from: accounts[0]}).then(function(drone0){
      assert.equal(drone0[0],2525252525257550,"Drone data not set correctly");
      assert.equal(drone0[5],00000000000000000000000005050505,"Drone data not set correctly");
    });
  });
  
//Ensure we can transfer drone ownership
  it("...should transfer drone ownership.", function(){
    return coreInstance.transfer(accounts[1],0,{from: accounts[0]}).then(function(){
      return coreInstance.balanceOf(accounts[1]).then(function(balance2) {
        assert.equal(balance2,1, "Drone not transfered");
      });
    });
  });
  
  //Put the drone up for sale
  //function createSaleAuction(uint256 _droneId, uint256 _startingPrice, uint256 _endingPrice, uint256 _duration)
  it("...should create drone auction.", function(){
    return coreInstance.createSaleAuction(0,10000,8000,3600,{from: accounts[1]}).then(function(){
      return saleInstance.getAuction(0).then(function(auctionInst0) {
        //assert.equal(1,1,"Not a real test");
        assert.equal(auctionInst0[0],accounts[1], "Seller not correct");
        assert.equal(auctionInst0[1],10000, "Starting Price not set correctly");
        assert.equal(auctionInst0[2],8000, "Ending Price not set correctly");
        assert.equal(auctionInst0[3],3600, "Duration not set correctly");
      });
    });
  });

  //Create a drone
  it("...should create a drone.", function() {
    return manufacturingInstance.manufacturePromoDrone(2525252525259040,00000000000000000000000002550755,accounts[1], {from: accounts[0]}).then(function() {
      return coreInstance.balanceOf(accounts[1]).then(function(balance3) {
        assert.equal(balance3,1, "Drone not created");
      });
    });
  });

  //Bid on the drone
  //Ensure the drone has switched owner
  it("...should bid on an auction.", function(){
    return saleInstance.bid(0,{from: accounts[0], to: saleInstance.address, value: 10000}).then(function(){
      return coreInstance.balanceOf(accounts[0]).then(function(balance3) {
        assert.equal(balance3,1, "Drone has not transferred ownership");
      });
    });
  });

  //Make a match
  //Initialise an environment
  it("...should create an environment", function(){
    return matchEnvironmentInstance.makeEnvironment(0,10102050,{from: accounts[0]}).then(function(){
      return matchEnvironmentInstance.getEnvironment(0,{from: accounts[0]}).then(function(environ0){
        assert.equal(environ0,10102050,"Environment not set");
      });
    });
  });

  //Use the environment to create a match
  it("...should create a match", function(){
    return matchEnvironmentInstance.makeMatch(0,10000,0,{from: accounts[0], to: matchEnvironmentInstance.address, value: 10000}).then(function(){
      return matchMakerInstance.getMatch(0,{from: accounts[0]}).then(function(match0){
        assert.equal(match0[0],accounts[0],"Match maker not set correctly");
        assert.equal(match0[1],10000,"Match cash not set correctly");
      });
    });
  });


  //Take a match
  it("...should take a match", function(){
    return matchMakerInstance.takeMatch(1,0,{from: accounts[1], to: matchMakerInstance.address, value: 10000}).then(function(){
        //Check winner
        return coreInstance.getDrone(0,{from: accounts[0]}).then(function(drone1){
          assert.equal(drone1[3],1,"Winner did not accumulate a victory");
        });       
    });
  });
  
  it("...should learn from its loss", function(){
    //Ensure the looser has learned from the fight
    return coreInstance.getDrone(1,{from: accounts[0]}).then(function(drone1){
      assert.equal(drone1[0],2525252625259040,"Looser did not learn");
    });
  });

  //Transfer our cut
    //Activate bid extraction
    it("...should transfer the bid balance", function(){
      //Ensure our cut from the sale has been transfered to core.
      return coreInstance.withdrawAuctionBalances({from: accounts[0]}).then(function(){
        var val = web3.eth.getBalance(coreInstance.address);
        assert.equal(val,9000,"Balance did not transfer");
      });
    });
    //Activate matchmaking extraction
    it("...should transfer the matchmaking balance", function(){
      //Ensure our cut from the sale has been transfered to core.
      return matchMakerInstance.withdrawBalance({from: accounts[0]}).then(function(){
        var val = web3.eth.getBalance(coreInstance.address);
        assert.equal(val,27000,"Balance did not transfer");
      });
    });

  //Extract our cut to the ethManager accounts[2]
  it("...should transfer the core balance", function(){
    var oldEthManVal = web3.eth.getBalance(accounts[2]);
    //Ensure the core value is sent to the ethManager account.
    return coreInstance.withdrawBalance({from: accounts[2]}).then(function(){
      var val = web3.eth.getBalance(coreInstance.address);
      var newEthManVal = web3.eth.getBalance(accounts[2]);
      var ethManValDiff = oldEthManVal - newEthManVal;
      assert.equal(val,0,"Balance did not transfer from");
      //3008399999975424 is the difference after we factor in the gas gan charges at gas price 1 in gan
      assert.equal(ethManValDiff,3008399999975424,"Balance did not transfer to");
    });
  });

  //Test auto-creation of drones for auction 1
  it("...should create a drone and put it on auction", function(){
      return manufacturingInstance.manufactureSaleDrone(2525252525257550,00000000000000000000000005050505,{from: accounts[0]}).then(function(){
        return saleInstance.getAuction(2).then(function(auctionInst1) {
          assert.equal(auctionInst1[0],coreInstance.address, "Seller not correct");
          assert.equal(auctionInst1[1],10000000000000000, "Starting Price not set correctly");
          assert.equal(auctionInst1[2],0, "Ending Price not set correctly");
          assert.equal(auctionInst1[3],86400, "Duration not set correctly");
        });
    });
  });

  //Test auto-creation of drones for auction 2
  it("...should create a drone and put it on auction", function(){
    return manufacturingInstance.manufactureSaleDrone(2525252525257550,00000000000000000000000005050505,{from: accounts[0]}).then(function(){
      return saleInstance.getAuction(3).then(function(auctionInst1) {
        assert.equal(auctionInst1[0],coreInstance.address, "Seller not correct");
        assert.equal(auctionInst1[1],10000000000000000, "Starting Price not set correctly");
        assert.equal(auctionInst1[2],0, "Ending Price not set correctly");
        assert.equal(auctionInst1[3],86400, "Duration not set correctly");
      });
    });
  });

  //Test auto-creation of drones for auction 3
  it("...should create a drone and put it on auction", function(){
    return manufacturingInstance.manufactureSaleDrone(2525252525257550,00000000000000000000000005050505,{from: accounts[0]}).then(function(){
      return saleInstance.getAuction(4).then(function(auctionInst1) {
        assert.equal(auctionInst1[0],coreInstance.address, "Seller not correct");
        assert.equal(auctionInst1[1],10000000000000000, "Starting Price not set correctly");
        assert.equal(auctionInst1[2],0, "Ending Price not set correctly");
        assert.equal(auctionInst1[3],86400, "Duration not set correctly");
      });
    });
  });

  //Test auto-creation of drones for auction 4
  it("...should create a drone and put it on auction", function(){
    return manufacturingInstance.manufactureSaleDrone(2525252525257550,00000000000000000000000005050505,{from: accounts[0]}).then(function(){
      return saleInstance.getAuction(5).then(function(auctionInst1) {
        assert.equal(auctionInst1[0],coreInstance.address, "Seller not correct");
        assert.equal(auctionInst1[1],10000000000000000, "Starting Price not set correctly");
        assert.equal(auctionInst1[2],0, "Ending Price not set correctly");
        assert.equal(auctionInst1[3],86400, "Duration not set correctly");
      });
    });
  });

  //Test auto-creation of drones for auction 5
  it("...should create a drone and put it on auction", function(){
    return manufacturingInstance.manufactureSaleDrone(2525252525257550,00000000000000000000000005050505,{from: accounts[0]}).then(function(){
      return saleInstance.getAuction(6).then(function(auctionInst1) {
        assert.equal(auctionInst1[0],coreInstance.address, "Seller not correct");
        assert.equal(auctionInst1[1],10000000000000000, "Starting Price not set correctly");
        assert.equal(auctionInst1[2],0, "Ending Price not set correctly");
        assert.equal(auctionInst1[3],86400, "Duration not set correctly");
      });
    });
  });

  //Bid on sale drones 1 (drone 2)
  it("...should bid on an auction.", function(){
    return saleInstance.bid(2,{from: accounts[0], to: saleInstance.address, value: 10000000000000000}).then(function(){
      return coreInstance.balanceOf(accounts[0]).then(function(balance3) {
        assert.equal(balance3,2, "Drone has not transferred ownership");
      });
    });
  });

  //Bid on sale drones 2 (drone 3)
  it("...should bid on an auction.", function(){
    return saleInstance.bid(3,{from: accounts[0], to: saleInstance.address, value: 10000000000000000}).then(function(){
      return coreInstance.balanceOf(accounts[0]).then(function(balance3) {
        assert.equal(balance3,3, "Drone has not transferred ownership");
      });
    });
  });

  //Bid on sale drones 3 (drone 4)
  it("...should bid on an auction.", function(){
    return saleInstance.bid(4,{from: accounts[0], to: saleInstance.address, value: 10000000000000000}).then(function(){
      return coreInstance.balanceOf(accounts[0]).then(function(balance3) {
        assert.equal(balance3,4, "Drone has not transferred ownership");
      });
    });
  });

  //Bid on sale drones 4 (drone 5)
  it("...should bid on an auction.", function(){
    return saleInstance.bid(5,{from: accounts[0], to: saleInstance.address, value: 10000000000000000}).then(function(){
      return coreInstance.balanceOf(accounts[0]).then(function(balance3) {
        assert.equal(balance3,5, "Drone has not transferred ownership");
      });
    });
  });

  //Bid on sale drones 5 (drone 6)
  it("...should bid on an auction.", function(){
    return saleInstance.bid(6,{from: accounts[0], to: saleInstance.address, value: 10000000000000000}).then(function(){
      return coreInstance.balanceOf(accounts[0]).then(function(balance3) {
        assert.equal(balance3,6, "Drone has not transferred ownership");
      });
    });
  });

  

  //Re-sell drone at higher value to push up average. This is the SEVENTH AUCTION in the tests (just to keep count)
  it("...should create & bid drone auction.", function(){
    return coreInstance.createSaleAuction(5,1000000000000000000,800000000000000000,86400,{from: accounts[0]}).then(function(){
      return saleInstance.bid(5,{from: accounts[4], to: saleInstance.address, value: 1000000000000000000}).then(function(){
        return coreInstance.balanceOf(accounts[4]).then(function(balance3) {
          assert.equal(balance3,1, "Drone has not transferred ownership");
        });
      });
    });
  });

  //Re-test auto-creation of drones for auction & Make sure their prices have updated based on previous bids
  it("...should create a drone and put it on auction", function(){
    return manufacturingInstance.manufactureSaleDrone(2525252525257550,00000000000000000000000005050505,{from: accounts[0]}).then(function(){
      return saleInstance.getAuction(7).then(function(auctionInst1) {
        assert.equal(auctionInst1[0],coreInstance.address, "Seller not correct");
        var priceIncrease = (auctionInst1[1]>10000000000000000);
        assert.equal(priceIncrease,true, "Starting Price not set correctly");
      });
    });
  });

  //Test drone manufacuring from pre-set lines.
  //Create line
  it("...should create a new drone line", function(){
    return manufacturingInstance.makeStandardLineID(0,00000000000000000000000005050505,{from: accounts[0]}).then(function(){
      return manufacturingInstance.getStandardLineID(0).then(function(lineIDinst1) {
        assert.equal(lineIDinst1,00000000000000000000000005050505, "LineID not correct");
      });
    });
  });

  //Manufacture line
  
  it("...should create a drone and put it on auction", function(){
    return manufacturingInstance.manufactureStandardDrone(0,{from: accounts[5], to: manufacturingInstance.address, value: 10000000000000000}).then(function(){
      return coreInstance.balanceOf(accounts[5]).then(function(balance8) {
        assert.equal(balance8,1, "Drone not created");
      });
    });
  });


  //Confirm manufacturing cash
  it("...should have been paid for the manufactured drone", function(){
      var val = web3.eth.getBalance(manufacturingInstance.address);
      assert.equal(val,10000000000000000,"Balance did not transfer");
  });

  //Initiate withdrawal to core contract
  it("...should transfer the manufacturing cash to the core", function(){
    var val1 = web3.eth.getBalance(coreInstance.address);
    return manufacturingInstance.withdrawBalance({from: accounts[0]}).then(function() {
      var val2 = web3.eth.getBalance(coreInstance.address);
      console.log(val1);
      console.log(val2);
      var increased = val2-val1;
      assert.equal(increased,10000000000000000,"Balance did not transfer");
    });
    
  });


});
