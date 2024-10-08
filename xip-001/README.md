---
title: System Smart Contract Transaction Fee Waiving Registry
description: System Smart Contract for waiving transaction fee.
author: sirawt (@MASDXI), Paramet Kongjaroen (@parametprame)
status: Draft
created: 2024-08-18
---

## Simple Summary

> ...

## Abstract

For the Enterprise and cooperate use case may facing problem gas used too high due to the smart contract are more complexity and make for specialize purpose to achieve the mass adoption of public blockchain.  
Waiving the gas used can reduce block space usage and also waiving the transaction fee.

## Motivation

Enterprise and corporate use cases often involve complex smart contracts tailored for specialized purposes. As these contracts grow in complexity, they typically consume more gas, leading to higher transaction costs. This can be a significant barrier to mass adoption of public blockchains within these sectors.

waiving the `gasUsed` when sender call transfer `ERC20` gas used around 50K in state-transition will check is the `ERC20` contract are in `allowList`  
if `true` then get `waive` otherwise do nothing.
Example if waiving is 50%
50% of 50K of gas used is 25k so the enterprise can create heavy logic and focus more on safety of the smart contract more than trying to reduce the gas used of the code it's self that maybe create unexpected vulnerabilities.

## Rationale

The mechanism uses an `allowList` to designate contracts eligible for gas waiving, along with a `_waivingRatio` that sets the percentage of gas to be waived. By selectively applying the waiver, we ensure that only specific, trusted contracts receive this benefit, which helps prevent misuse. The ability to adjust the waiving ratio allows us to tailor the waiver based on the particular requirements and risks of each contract.

This strategy makes it more financially viable for enterprises to leverage public blockchains L1 or L2 that focus on the cooperate and enterprise use case, while not too strive to create a heavy optimized smart contract that could have potentially to have a vulnerabilities.

## Interface

events
``` solidity
event waiveUpdated(address indexed _contract, uint256 oldRatio, uint256 newRatio);
```

``` solidity
event allowListGranted(address indexed _contract, uint256 ratio);
```

``` solidity
event allowListRevoked(address indexed _contract);
```

errors
``` solidity
error InvalidRatio(uint256 ratio, string message);
```

``` solidity
error Unauthorized();
```

function
``` solidity
function setWaive(address contractAddr, uint256 newRatio) external returns (uint256);
```

``` solidity
function grantAllowList(address contractAddr, uint256 ratio) external returns (bool);
```

``` solidity
function revokeAllowList(address contractAddr) external returns (bool);
```

``` solidity
function waive(address contractAddr) external view returns (bool isAllowList, uint256 waivingRatio);
```

## Security Considerations

When waiving by overwrite 100% of the gas used to `zero` on the transaction means the transaction will not consume any gas from the sender and not consume any gas from the gas pool `(blockGasLimit)`,  
to mitigate create condition checking waiving ratio in length from `MINIMUM_VALUE` to `MAXIMUM_VALUE`.  
- It's could be potential to create Distributed Denial of Service(DDoS).  
- Validator can be increase their accepted `gasPrice`. to maintain their profit.  

## Historical links related to this standard

- Ethereum Yellow Paper (Gas Calculation Logic)
- EIP-1559

## License
Release under the [Apache-2.0](LICENSE) license.   
Copyright (C) to author. All rights reserved.