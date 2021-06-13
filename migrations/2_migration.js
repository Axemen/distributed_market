const Market = artifacts.require("Market");
const IdGenerators = artifacts.require("IdGenerators");

module.exports = function (deployer) {
  deployer.deploy(IdGenerators);
  deployer.link(IdGenerators, Market);
  deployer.deploy(Market);
};
