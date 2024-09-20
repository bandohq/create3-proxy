# CREATE3 for Upgradeable Proxies

[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/bandohq/create3-proxy/blob/main/LICENSE)
[![npm version](https://img.shields.io/npm/v/create3-proxy.svg)](https://www.npmjs.com/package/create3-proxy)
[![Build Status](https://github.com/bandohq/create3-proxy/workflows/CI/badge.svg)](https://github.com/bandohq/create3-proxy/actions)


A Solidity library for deploying upgradeable proxies using the CREATE3 pattern, enabling deterministic addresses across different chains without relying on nonces or code.

## Overview

CREATE3 Proxy combines the power of CREATE3 for deterministic contract deployment with the upgradeability of UUPS (Universal Upgradeable Proxy Standard) proxies. This library allows developers to deploy upgradeable contracts to the same address across multiple networks, simplifying cross-chain development and management.

## Features

- Deterministic addresses across different chains
- UUPS (ERC1967) proxy pattern for upgradeability
- Gas-efficient deployment using CREATE3
- Easy-to-use interface for deploying proxies

## Installation

To install with Foundry:

```bash
forge install bandohq/create3-proxy
```

## Usage

To use the library in your project, follow these steps:

### Deploy a UUPS (ERC1967) Proxy

1. Import the library into your contract:

```solidity
import "create3-proxy/src/CREATE3UUPSProxy.sol";
```

2. Deploy using your implementation contract:

```solidity
bytes32 salt = keccak256("my_proxy");
bytes memory creationCode = type(MyUUPSContract).creationCode;
bytes memory initializerData = abi.encodeWithSignature("myInitialize(uint256)", initialValue);
address proxy = CREATE3UUPSProxy.deploy(salt, creationCode, initializerData);
```

## Contributing

We welcome contributions to this library. Please open an issue or submit a pull request.
Read more on our [contributing guidelines](./CONTRIBUTING.md).

### Code of Conduct

We have a [code of conduct](./CODE_OF_CONDUCT.md) that we expect all contributors to adhere to.

### Building from source

```bash
forge build
```

### Test

```bash
forge test
```
