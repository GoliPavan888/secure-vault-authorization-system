// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol";

contract AuthorizationManager {
    using ECDSA for bytes32;
    using MessageHashUtils for bytes32;

    address public owner;
    uint256 public immutable chainId;

    mapping(bytes32 => bool) private usedAuthorizations;

    event AuthorizationConsumed(bytes32 indexed authId, address indexed vault);

    modifier onlyOnce() {
        require(owner == address(0), "Already initialized");
        _;
    }

    constructor() {
        chainId = block.chainid;
    }

    function initialize(address _owner) external onlyOnce {
        owner = _owner;
    }

    function verifyAuthorization(
        address vault,
        address recipient,
        uint256 amount,
        bytes32 authId,
        bytes calldata signature
    ) external returns (bool) {
        require(!usedAuthorizations[authId], "Authorization already used");

        bytes32 digest = keccak256(
            abi.encodePacked(
                vault,
                recipient,
                amount,
                chainId,
                authId
            )
        ).toEthSignedMessageHash();

        address signer = digest.recover(signature);
        require(signer == owner, "Invalid authorization");

        usedAuthorizations[authId] = true;

        emit AuthorizationConsumed(authId, vault);

        return true;
    }
}
