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

module.exports = function(deployer) {
  deployer.deploy(Ownable);
  deployer.link(Ownable,[Killable,Pausable]);
  deployer.deploy(Killable);
  deployer.link(Killable, Authentication);
  deployer.deploy(Authentication);
  deployer.deploy(Pausable);
  deployer.deploy(ERC721);
  deployer.deploy(EtherWarzRoleManagement);

  deployer.link(EtherWarzRoleManagement,[SmartDroneOwnership,SmartDroneBase]);
  deployer.deploy(SmartDroneBase);
  deployer.deploy(ERC721Metadata);
  deployer.deploy(AIScienceInterface);
  deployer.link(SmartDroneBase,[SmartDroneOwnership]);
  deployer.link(ERC721, [SmartDroneOwnership,ClockAuctionBase]);
  deployer.deploy(SmartDroneOwnership);
  deployer.deploy(ClockAuctionBase);

};
