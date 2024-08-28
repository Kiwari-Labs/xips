# Stateful precompiled contract Specification

## Introduction

A stateful precompiled contract can be a key feature that sets your blockchain network apart from others.  
Adding a stateful precompiled contract to your client is an approach that surpasses the limitations of the EVM and  
traditional smart contracts by enabling the processing of large-scale and complex operations with the native speed of your client’s language.

#### Determining the Stateful Precompiled Contract Address

This section explains how the address of the stateful precompiled contract, `CONTRACT_ADDRESS`, is calculated.

```
var contractAddress = keccak256("<CONTRACT_NAME>").toString().slice(0, 20)
```
1. Hash the Contract Name: The contract name is hashed using the keccak256 algorithm.
2. Extract the Address: The resulting hash is then converted to a string, and the first 20 characters are taken as the contract's address.  
This method ensures a unique and consistent address for the stateful precompiled contract based on its name.

#### Rationale for Stateful precompiled address Calculation
This approach to calculating the stateful precompiled contract address avoids the need to manually remember or assign specific addresses.  
By deriving the address from the contract name using a keccak256 hash,  
we eliminate the risk of address conflicts that could arise from using a fixed or incrementally assigned address scheme.

This method ensures that the address is unique and deterministic, which helps maintain compatibility and avoids potential conflicts with the main Ethereum development track.  
It also simplifies deployment, as the address does not need to be manually managed or updated.


## For Future Stateful Precompiled Contract Pattern

| CONTRACT_NAME | CONTRACT_ADDRESS                           |
| ------------- | ------------------------------------------ |
| CATEGORY:NAME | `0x00000000000000000000000000000000000000` |

## Utilities Category

| CONTRACT_NAME        | CONTRACT_ADDRESS                             |
| -------------------- | -------------------------------------------- |
| UTILS:HTTPS_CALL     | `0xb736a409c1d8ba65ca3c98e2b44b4ec50f5cf079` |
| UTILS:RANDOM         | `0x9053970af851b0cddb2eb2fa3d37ba31a5fec999` |
| UTILS:SLIDING_WINDOW | `0xe7785dd2967f2a0930ea0123e299ec83b0ce60d2` |

## Data Structure and Storage Category

| CONTRACT_NAME                                     | CONTRACT_ADDRESS                             |
| ------------------------------------------------- | -------------------------------------------- |
| DATA_STRUCTURE:SORTED_CIRCULAR_DOUBLY_LINKED_LIST | `0xe2a2256098eafc2dd3b907c81d9719d4f569b6c2` |
| DATA_STRUCTURE:SORTED_CIRCULAR_SINGLY_LINKED_LIST | `0x29ab52be1bd6a4159cfee00a0869e48f2f5de3da` |
| DATA_STRUCTURE:SORTED_DOUBLY_LINKED_LIST          | `0x6170a593037251fb057d8a9fe501ce6c832dfa1d` |
| DATA_STRUCTURE:SORTED_SINGLY_LINKED_LIST          | `0x216530f7b80cdbea5ffaa134061410cb9c35240e` |

## Financial Category

| CONTRACT_NAME                  | CONTRACT_ADDRESS                              |
| ------------------------------ | --------------------------------------------- |
| FINANCIAL:SETTLEMENT:CLS       | `0xf1d7d58f133a805f4676df01f0b724f27fc64423`  |
| FINANCIAL:SETTLEMENT:DVP       | `0x8757042abeb11d61500724c0eb2310142295b7a8 ` |
| FINANCIAL:SETTLEMENT:FOP       | `0xa81ea3cf493f9c551314efcfe495efcc7c8157d4`  |
| FINANCIAL:SETTLEMENT:GROSS     | `0xef2a2090b17c91a212355a65577448fe99380d4b`  |
| FINANCIAL:SETTLEMENT:GRID_LOCK | `0x71872a61c12b42641a7b0c50b333773a036543d4`  |
| FINANCIAL:SETTLEMENT:NET       | `0xccbce07a88e8e90406474f5d6c95a047816f9ae8`  |
| FINANCIAL:SETTLEMENT:NOVATION  | `0x4a3ce74d343d60b7987923b2e7565e74d3ee3fc0`  |
| FINANCIAL:SETTLEMENT:PVP       | `0x68deaf43f64df1c70c6f7777704e2f1942cad6cd`  |

## Transactions Types Category

| CONTRACT_NAME    | CONTRACT_ADDRESS                             |
| ---------------- | -------------------------------------------- |
| TX_MODEL:ACCOUNT | `0x2b7a45fa0055dcc1694c681c908722f12b66a8ce` |
| TX_MODEL:EUTXO   | `0x3bc923f9e1d3165e228a0b1592db69efa924f027` |
| TX_MODEL:UTXO    | `0x7f166d6bcc7a2f9c79db9214e8eba3feab5ad4d9` |


### Glossary

Enterprise Solidity (EnSol)
Continuous Linked Settlement (CLS)  
Delivery Versus Payment (DvP)  
Free of Payment (FoP)  
Payment Versus Payment (PvP)
