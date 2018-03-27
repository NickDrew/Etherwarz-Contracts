
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
var Matchmaker = artifacts.require("MatchMaker");
var MatchmakerBase = artifacts.require("MatchmakerBase");
var ClockAuctionBase = artifacts.require("ClockAuctionBase");
var Manufacturing = artifacts.require("Manufacturing");
var ManufacturingInterface = artifacts.require("ManufacturingInterface");
var AIScience = artifacts.require("AIScience");
var ClockAuction = artifacts.require("ClockAuction");
var MatchEnvironment = artifacts.require("MatchEnvironment");
var MatchEnvironmentInterface = artifacts.require("MatchEnvironmentInterface");

module.exports = function(deployer) {
    deployer.deploy(MatchEnvironment,SmartDroneCore.address);
    deployer.deploy(MatchEnvironmentInterface).then(function(){
            deployer.link(MatchEnvironmentInterface,[MatchEnvironment,Matchmaker]);
            deployer.link(Ownable,MatchEnvironment);
            deployer.link(Matchmaker, MatchEnvironment);   
    });
};
