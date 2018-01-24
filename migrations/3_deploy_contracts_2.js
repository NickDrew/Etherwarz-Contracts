var AIScienceInterface = artifacts.require("AIScienceInterface");
var WarInterface = artifacts.require("WarInterface");
var Authentication = artifacts.require("Authentication");
var ClockAuction = artifacts.require("ClockAuction");
var ClockAuctionBase = artifacts.require("ClockAuctionBase");
var ERC721 = artifacts.require("ERC721");
var ERC721Metadata = artifacts.require("ERC721Metadata");
var EtherWarzRoleManagement = artifacts.require("EtherWarzRoleManagement")
var Killable = artifacts.require("Killable");
var Ownable = artifacts.require("Ownable");
var Pausable = artifacts.require("Pausable");
var SaleClockAuction = artifacts.require("SaleClockAuction");
var SmartDroneAuction = artifacts.require("SmartDroneAuction");
var SmartDroneBase = artifacts.require("SmartDroneBase");
var SmartDroneCore = artifacts.require("SmartDroneCore");
var SmartDroneMinting = artifacts.require("SmartDroneMinting");
var SmartDroneOwnership = artifacts.require("SmartDroneOwnership");
var SmartDroneWar = artifacts.require("SmartDroneWar");
var AIScience = artifacts.require("AIScience");

module.exports = function(deployer) {
  
    deployer.link(EtherWarzRoleManagement,[SmartDroneAuction,SmartDroneMinting,SmartDroneWar,SmartDroneCore]);
    deployer.link(SmartDroneBase,[SmartDroneAuction,SmartDroneMinting,SmartDroneWar,SmartDroneCore]);
    deployer.link(ClockAuctionBase,[ClockAuction,SaleClockAuction]);
    deployer.link(ERC721,[ClockAuction,SmartDroneAuction,SmartDroneMinting,SmartDroneWar,SmartDroneCore]);
    deployer.link(Ownable, [ClockAuction,SaleClockAuction]);
    deployer.link(Pausable,[ClockAuction,SaleClockAuction,ClockAuction]);
    deployer.deploy(ClockAuction,SmartDroneOwnership.address,9000);
    deployer.link(ClockAuction,SaleClockAuction);
    deployer.deploy(SaleClockAuction,SmartDroneOwnership.address,9000);
    deployer.link(SaleClockAuction,[SmartDroneAuction,SmartDroneMinting]);
    deployer.link(SmartDroneOwnership,[SmartDroneMinting,SmartDroneCore,SmartDroneWar,SmartDroneAuction]);
    deployer.link(AIScienceInterface, [AIScience]);
    deployer.deploy(SmartDroneAuction);
    deployer.link(SmartDroneAuction,[SmartDroneMinting,SmartDroneWar,SmartDroneCore]);
    deployer.deploy(AIScience);
    deployer.deploy(SmartDroneMinting);
    deployer.link(SmartDroneMinting,[SmartDroneWar,SmartDroneCore]);
    deployer.deploy(SmartDroneWar);
    deployer.link(SmartDroneWar,SmartDroneCore);
  

};
