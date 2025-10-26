// This setup uses Hardhat Ignition to manage smart contract deployments.
// Learn more about it at https://hardhat.org/ignition

import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";
import { NftAuctionProxyModule } from "./NftAuction";


//sepolia deployment addresses:
export const NftAuctionV2Module = buildModule("NftAuctionV2Module", (m) => {
  const deployer = m.getAccount(0);

  const { proxy: proxyFuture } = m.useModule(NftAuctionProxyModule);

  // Fetch the callable proxy contract
  const proxy = m.contractAt("NftAuction", proxyFuture);

  // Deploy the new implementation contract
  const newImplementation = m.contract("NftAuctionV2"); // Replace with the upgraded contract name
  // Call the upgradeTo function on the proxy to point to the new implementation
  m.call(proxy, "upgradeToAndCall", [newImplementation, "0x"], {
    from: deployer,
  });

  return { newImplementation };
})


export default NftAuctionV2Module;
