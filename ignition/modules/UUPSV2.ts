// This setup uses Hardhat Ignition to manage smart contract deployments.
// Learn more about it at https://hardhat.org/ignition

import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";
import { ProxyModule } from "./UUPS";


//sepolia deployment addresses:
// BoxV2 - 0xd50E8cD05d41D74B7F9611176fCfD5E255834Ef2
export const BoxV2Module = buildModule("BoxV2Module", (m) => {
  const deployer = m.getAccount(0);

  const { proxy: proxyFuture } = m.useModule(ProxyModule);

  // Fetch the callable proxy contract
  const proxy = m.contractAt("Box", proxyFuture);

  // Deploy the new implementation contract
  const newImplementation = m.contract("BoxV2"); // Replace with the upgraded contract name
  // Call the upgradeTo function on the proxy to point to the new implementation
  m.call(proxy, "upgradeToAndCall", [newImplementation, "0x"], {
    from: deployer,
  });

  return { newImplementation };
})


export default BoxV2Module;
