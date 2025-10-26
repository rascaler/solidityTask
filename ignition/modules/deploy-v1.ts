const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

const MyContractV1Module = buildModule("MyContractV1Module", (m) => {
  // 部署逻辑合约 V1
  const myContractV1 = m.contract("MyContractV1", [], {});

  // 部署代理，并调用 initialize()
  const proxy = m.contract("MyContractV1", {
    args: [],
    viaProxy: {
      kind: "uups",
      proxyContract: "ERC1967Proxy",
    },
    afterDeploy: async (contract, contractFactory, run) => {
      await contract.initialize();
      return contract;
    },
  });

  return {
    myContractV1,
    proxy,
  };
});
export default MyContractV1Module;