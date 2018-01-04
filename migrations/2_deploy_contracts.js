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
  deployer.link(Ownable, [Killable,ClockAuction]);
  deployer.deploy(Killable);
  deployer.link(Killable, Authentication);
  deployer.deploy(Authentication);
  deployer.link(Ownable,[ClockAuction,SaleClockAuction,ClockAuction,Pausable]);
  deployer.deploy(Pausable);
  deployer.link(Pausable,ClockAuction);
  deployer.deploy(ERC721);
  deployer.link(ERC721,ClockAuction);
  deployer.deploy(EtherWarzRoleManagement);

  deployer.link(EtherWarzRoleManagement,[SmartDroneMinting,SmartDroneCore,SmartDroneAuction,SmartDroneManufacturing,SmartDroneOwnership,SmartDroneBase]);
  deployer.deploy(SmartDroneBase);
    deployer.deploy(ERC721Metadata);
    deployer.deploy(AIScienceInterface);
    deployer.link(SmartDroneBase,[SmartDroneMinting,SmartDroneCore,SmartDroneAuction,SmartDroneManufacturing,SmartDroneOwnership]);
    deployer.link(ERC721, [SmartDroneMinting,SmartDroneCore,SmartDroneAuction,SmartDroneManufacturing,SmartDroneOwnership,ClockAuctionBase,ClockAuction]);
    deployer.deploy(SmartDroneOwnership)
      deployer.deploy(ClockAuctionBase);
      deployer.link(Pausable,[ClockAuction,SaleClockAuction,ClockAuction]);
      deployer.link(ClockAuctionBase,[ClockAuction,SaleClockAuction]);
      deployer.deploy(ClockAuction,SmartDroneOwnership.address,9000);
      deployer.link(ClockAuction,SaleClockAuction);
      deployer.deploy(SaleClockAuction,SmartDroneOwnership.address,9000);
      deployer.link(SmartDroneOwnership,[SmartDroneMinting,SmartDroneCore,SmartDroneAuction,SmartDroneManufacturing]);
      deployer.link(AIScienceInterface, SmartDroneManufacturing);
      deployer.deploy(SmartDroneManufacturing);
      deployer.link(SmartDroneManufacturing,[SmartDroneMinting,SmartDroneCore,SmartDroneAuction]);
      deployer.deploy(SmartDroneAuction);
      deployer.link(SmartDroneAuction,[SmartDroneMinting,SmartDroneCore]);
      deployer.deploy(SmartDroneMinting);
      deployer.link(SmartDroneMinting,SmartDroneCore);
      deployer.deploy(SmartDroneCore);

};
