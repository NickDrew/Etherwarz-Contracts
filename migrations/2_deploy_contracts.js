var AIScienceInterface = artifacts.require("AIScienceInterface")
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
var SmartDroneManufacturing = artifacts.require("SmartDroneManufacturing");
var SmartDroneMinting = artifacts.require("SmartDroneMinting");
var SmartDroneOwnership = artifacts.require("SmartDroneOwnership");

module.exports = function(deployer) {
  deployer.deploy(Ownable);
  deployer.link(Ownable, Killable);
  deployer.deploy(Killable);
  deployer.link(Killable, Authentication);
  deployer.deploy(Authentication);
  deployer.link(Ownable,Pausable);
  deployer.deploy(Pausable);
  deployer.deploy(ERC721);
  deployer.deploy(EtherWarzRoleManagement);

  deployer.link(SmartDroneBase,EtherWarzRoleManagement);
  deployer.deploy(EtherWarzRoleManagement);
  deployer.deploy(ERC721Metadata);
  deployer.deploy(AIScienceInterface);
  deployer.link(SmartDroneBase,SmartDroneOwnership);
  deployer.link(ERC721, SmartDroneOwnership).then (function() {
    deployer.deploy(SmartDroneOwnership).then (function() {
      deployer.deploy(ClockAuctionBase);
      deployer.link(Pausable,ClockAuction);
      deployer.link(ClockAuctionBase,ClockAuction);
      deployer.deploy(ClockAuction,SmartDroneOwnership.address,9000);
      deployer.link(ClockAuction,SaleClockAuction);
      deployer.deploy(SaleClockAuction);
    });
  });
  
  deployer.link(SmartDroneOwnership,SmartDroneManufacturing);
  deployer.deploy(SmartDroneManufacturing);
  deployer.link(SmartDroneManufacturing,SmartDroneAuction);
  deployer.deploy(SmartDroneAuction);
  deployer.link(SmartDroneAuction,SmartDroneMinting);
  deployer.deploy(SmartDroneMinting);
  deployer.link(SmartDroneMinting,SmartDroneCore);
  deployer.deploy(SmartDroneCore);
};
