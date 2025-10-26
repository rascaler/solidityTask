const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

const UpgradeToV2Module = buildModule("UpgradeToV2Module", (m) => {
  // 依赖之前的部署
  const { proxy } = m.useModule(require("./deploy-v1"));

  // 部署新逻辑合约 V2
  const myContractV2 = m.contract("MyContractV2", [], {});

  // 升级代理指向 V2
  const upgradedProxy = m.upgradeProxy("MyContractV2", proxy, myContractV2, {
    afterUpgrade: async (contract, contractFactory, run) => {
      // 可选：升级后执行一些操作，比如调用新函数
      await contract.upgradeToV2();
      return contract;
    },
  });

  return {
    myContractV2,
    upgradedProxy,
  };
});

export default UpgradeToV2Module;
