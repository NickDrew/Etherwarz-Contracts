
var EtherWarzRoleManagement = artifacts.require("EtherWarzRoleManagement");
var SmartDroneMatchMaking = artifacts.require("SmartDroneMatchMaking");
var SmartDroneBase = artifacts.require("SmartDroneBase");
var SmartDroneCore = artifacts.require("SmartDroneCore");
var SmartDroneMinting = artifacts.require("SmartDroneMinting");
var SmartDroneOwnership = artifacts.require("SmartDroneOwnership");
var SmartDroneWar = artifacts.require("SmartDroneWar");
var SmartDroneAuction = artifacts.require("SmartDroneAuction");
var Killable = artifacts.require("Killable");
var Ownable = artifacts.require("Ownable");
var Pausable = artifacts.require("Pausable");
var SaleClockAuction = artifacts.require("SaleClockAuction");
var WarInterface = artifacts.require("WarInterface");
var WarResolution = artifacts.require("WarResolution");
var ERC721 = artifacts.require("ERC721");
var ERC721Match = artifacts.require("ERC721Match");
var Matchmaker = artifacts.require("Matchmaker");
var MatchmakerBase = artifacts.require("MatchmakerBase");
var ClockAuctionBase = artifacts.require("ClockAuctionBase");

var ClockAuction = artifacts.require("ClockAuction");

module.exports = function(deployer) {
 
    deployer.deploy(Matchmaker,SmartDroneCore.address,9000)
    deployer.deploy(WarResolution);
    deployer.deploy(WarInterface).then(function(){
      
            deployer.link(WarResolution,SmartDroneCore);
            deployer.link(SmartDroneBase,SmartDroneMatchMaking);
            deployer.link(ERC721,[SmartDroneMatchMaking,ERC721Match,Matchmaker,MatchmakerBase]);
            deployer.link(ERC721Match,[SmartDroneAuction,SmartDroneMinting,SmartDroneWar,SmartDroneCore,SmartDroneOwnership,SmartDroneMatchMaking,Matchmaker,MatchmakerBase])
            deployer.link(SmartDroneMatchMaking,SmartDroneCore);
            deployer.link(SmartDroneBase,SmartDroneMatchMaking);
            deployer.link(SmartDroneAuction,SmartDroneMatchMaking);
            deployer.link(SmartDroneMinting,SmartDroneMatchMaking);
            deployer.link(SmartDroneOwnership,SmartDroneMatchMaking);
            deployer.link(SmartDroneWar,SmartDroneMatchMaking);
            deployer.link(WarInterface,WarResolution);
            deployer.link(WarResolution,SmartDroneWar);
            deployer.link(WarResolution,SmartDroneMatchMaking);
            deployer.link(WarResolution,SmartDroneCore);
            deployer.link(MatchmakerBase,[Matchmaker,SmartDroneMatchMaking,SmartDroneCore]);
            deployer.link(Matchmaker,[SmartDroneMatchMaking,SmartDroneCore]);
       
    });
};
