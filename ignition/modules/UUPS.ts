// This setup uses Hardhat Ignition to manage smart contract deployments.
// Learn more about it at https://hardhat.org/ignition

import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";
// sepolia deployment addresses:
// ProxyModule#Box - 0xe6c1EC9c5F3DC65a1aF8C833e0dC1D686374cCc8
// ProxyModule#ERC1967Proxy - 0x0F809Aef492aDC52Bf70c13B6964b74048D38aF3
export const ProxyModule = buildModule('ProxyModule', (builder) => {
  // Deploy the implementation contract
  const implementation = builder.contract('Box');

  // Encode the initialize function call for the contract.
  const initialize = builder.encodeFunctionCall(implementation, 'initialize', []);

  // Deploy the ERC1967 Proxy, pointing to the implementation
  const proxy = builder.contract('ERC1967Proxy', [implementation, initialize]);

  return { proxy };
});

export const BoxModule = buildModule('BoxModule', (builder) => {
  // Get the proxy from the previous module.
  const { proxy } = builder.useModule(ProxyModule);

  // Create a contract instance using the deployed proxy's address.
  const instance = builder.contractAt('Box', proxy);

  return { instance, proxy };
});


export default BoxModule;
