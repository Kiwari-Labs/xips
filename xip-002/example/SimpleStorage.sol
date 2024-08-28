// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Example Simple Storage with Stateful Precompiled Contract.
/// @author Kiwari Labs

// interface ISimpleStorageStateful {
//     function get() external view returns (uint256);
//     function set(uint256) external;
// }

library SimpleStorageStatefulLib {

    function get(address s) internal view returns (uint256) {
        (bool success, bytes memory data) = s.staticcall(
            abi.encodeWithSignature("get()")
        );
        require(success);
        return abi.decode(data, (uint256));
    }

    function set(address s, uint256 x) internal {
        (bool success, ) = s.call(
            abi.encodeWithSignature("set(uint256)", x)
        );
        require(success);
    }

}

contract StatefulTest {
    using SimpleStorageStatefulLib for address;
    // Common implementation not recommended.
    // reserve address is a unique address that is not meaningful and hard to remember.
    // address public statefulPrecompiled = <STATEFUL_PRECOMPILE_ADDRESS>;
    
    // Preferred implementation recommended.
    // purpose reserve address is generated from the hash of services:<name>.
    // @dev declaration address type.
    // address public simpleStorageAddress = address((bytes20(keccak256("simplestorage"))));

    // [SUGGESTION] reserve address determind guidance.
    // name space for stateful pre-compiled contract.
    // pattern: 
    //   <CATAGORY_TYPES>:<PRE_COMPIED_CONTRACT_NAME>
    //   <CATAGORY_TYPES>:<PRE_COMPIED_CONTRACT_NAME>:<VERSION> or <TYPE> optional.
    //
    // example:
    //   FINANCIAL:CORE_BANKING
    //   FINANCIAL:CORE_BANKING:V2
    //   FINANCIAL:SETTELMENT:GRIDLOCK
    //   FINANCIAL:SETTELMENT:NETTING
    //   UTILITY:HASH:CRC-32
    //   UTILITY:PRNG
    //   UTILITY:PRNG:OP-TEE
    //   DID:W3C:V1
    //   IP:1234 (IP:Improvement Proposal)

    // @dev constructor declaration.
    // constructor (string memory statefulPrecompiledName_) {
    //     simpleStorageAddress = 
    //         address((bytes20(keccak256(abi.encodePacked(statefulPrecompiledName_)))));
    // }

    // ISimpleStorageStateful public statefulPrecompiled;
    address public statefulPrecompiledAddress;

    event StorageUpdated(uint256 value);

    constructor(address precomplied) {
        statefulPrecompiledAddress = precomplied;
    }

    function testSet(uint256 value) public {
        statefulPrecompiledAddress.set(value);

        emit StorageUpdated(statefulPrecompiledAddress.get());
    }

    function testGet() public view returns (uint256) {
        return statefulPrecompiledAddress.get();
    }
}