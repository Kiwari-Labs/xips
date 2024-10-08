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

## Specification

Interface of the smart contract.
```solidity
// SPDX-License-Identifier: Apache-2.0
pragma solidity >=0.8.0 <0.9.0;

interface IWaiving {
    event waiveUpdated(
        address indexed _contract,
        uint256 oldRatio,
        uint256 newRatio
    );

    event allowListGranted(address indexed _contract, uint256 ratio);
    event allowListRevoked(address indexed _contract);

    error InvalidRatio(uint256 ratio, string message);
    error Unauthorized();

    /**
     * @dev Sets the waiving ratio for a specified contract address.
     * @param contractAddr The address of the contract to set the waiving ratio for.
     * @param newRatio The waiving ratio value to set, represented as a percentage scaled by DECIMALS.
     *              For example, to set 50.5%, pass in 505 (since DECIMALS = 1000).
     * @notice The function validates the contract address is in the allow list and the ratio is valid.
     * @notice Emits a {waiveUpdated} event.
     */
    function setWaive(
        address contractAddr,
        uint256 newRatio
    ) external returns (uint256);

    /**
     * @dev Grants allow list status and sets the waiving ratio for a specified contract address.
     * @param contractAddr The address of the contract to set the allow list status for.
     * @param ratio The waiving ratio value to set, represented as a percentage scaled by DECIMALS.
     * @notice Emits an {allowListGranted} event.
     */
    function grantAllowList(
        address contractAddr,
        uint256 ratio
    ) external returns (bool);

    /**
     * @dev Revokes allow list status for a specified contract address.
     * @param contractAddr The address of the contract to revoke the allow list status for.
     * @notice Emits an {allowListRevoked} event.
     */
    function revokeAllowList(address contractAddr) external returns (bool);

    /**
     * @dev Returns the allow list status and waiving ratio for a specified contract address.
     * @param contractAddr The address of the contract to get the allow list status and waiving ratio for.
     * @return isAllowList The allow list status.
     * @return waivingRatio The waiving ratio.
     */
    function waive(
        address contractAddr
    ) external view returns (bool isAllowList, uint256 waivingRatio);
}

```

The smart contract.
```solidity
// SPDX-License-Identifier: Apache-2.0
pragma solidity >=0.8.0 <0.9.0;

import "./interfaces/IWaiving.sol";

contract Waiving is IWaiving {
    mapping(address => bool) private _allowList;
    mapping(address => uint256) private _waivingRatio;

    uint256 constant DECIMALS = 1000;

    /// @inheritdoc IWaiving
    function setWaive(
        address contractAddr,
        uint256 newRatio
    ) external override returns (uint256) {
        _validateAllowList(contractAddr);
        _validateRaio(newRatio);

        uint256 oldRatio = _waivingRatio[contractAddr];
        _waivingRatio[contractAddr] = newRatio;

        emit waiveUpdated(contractAddr, oldRatio, newRatio);

        return newRatio;
    }

    /// @inheritdoc IWaiving
    function grantAllowList(
        address contractAddr,
        uint256 ratio
    ) external override returns (bool) {
        _validateRaio(ratio);

        _allowList[contractAddr] = true;
        _waivingRatio[contractAddr] = ratio;

        emit allowListGranted(contractAddr, ratio);

        return _allowList[contractAddr];
    }

    /// @inheritdoc IWaiving
    function revokeAllowList(
        address contractAddr
    ) external override returns (bool) {
        _allowList[contractAddr] = false;
        _waivingRatio[contractAddr] = 0;

        emit allowListRevoked(contractAddr);

        return _allowList[contractAddr];
    }

    /// @inheritdoc IWaiving
    function waive(
        address contractAddr
    ) external view override returns (bool, uint256) {
        return (_allowList[contractAddr], _waivingRatio[contractAddr]);
    }

    function _validateAllowList(address _contractAddr) private view {
        if (!_allowList[_contractAddr]) {
            revert Unauthorized();
        }
    }

    function _validateRaio(uint256 _ratio) private pure {
        if (_ratio <= 0 || _ratio > DECIMALS) {
            revert InvalidRatio(
                _ratio,
                "ERROR: Invalid ratio. Must be between 0 and 1000"
            );
        }
    }
}
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

[Apache-2.0](./LICENSE.md).