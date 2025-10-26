
import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";
export const NftAuctionProxyModule = buildModule('NftAuctionProxyModule', (builder) => {
  // Deploy the implementation contract
  const implementation = builder.contract('NftAuction');

  // Encode the initialize function call for the contract.
  const initialize = builder.encodeFunctionCall(implementation, 'initialize', []);

  // Deploy the ERC1967 Proxy, pointing to the implementation
  const proxy = builder.contract('ERC1967Proxy', [implementation, initialize]);

  return { proxy };
});

export const NftAuctionModule = buildModule('NftAuctionModule', (builder) => {
  // Get the proxy from the previous module.
  const { proxy } = builder.useModule(NftAuctionProxyModule);

  // Create a contract instance using the deployed proxy's address.
  const instance = builder.contractAt('NftAuction', proxy);

  return { instance, proxy };
});

export default NftAuctionModule;
