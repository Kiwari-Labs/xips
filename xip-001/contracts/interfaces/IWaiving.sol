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
