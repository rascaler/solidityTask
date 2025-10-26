import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

export const NftAuctionFactoryModule = buildModule('NftAuctionFactoryModule', (builder) => {
  // Get the proxy from the previous module.

  // Create a contract instance using the deployed proxy's address.
  const instance = builder.contract('NftAuctionFactory');

  return { instance };
});

export default NftAuctionFactoryModule;
