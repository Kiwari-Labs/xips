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
