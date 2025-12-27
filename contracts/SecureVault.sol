// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IAuthorizationManager {
    function verifyAuthorization(
        address vault,
        address recipient,
        uint256 amount,
        bytes32 authId,
        bytes calldata signature
    ) external returns (bool);
}

contract SecureVault {
    IAuthorizationManager public immutable authManager;
    uint256 public totalWithdrawn;

    event Deposit(address indexed from, uint256 amount);
    event Withdrawal(address indexed to, uint256 amount, bytes32 indexed authId);

    constructor(address authorizationManager) {
        authManager = IAuthorizationManager(authorizationManager);
    }

    receive() external payable {
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(
        address recipient,
        uint256 amount,
        bytes32 authId,
        bytes calldata signature
    ) external {
        bool ok = authManager.verifyAuthorization(
            address(this),
            recipient,
            amount,
            authId,
            signature
        );
        require(ok, "Authorization failed");

        totalWithdrawn += amount;
        require(address(this).balance >= amount, "Insufficient vault balance");

        (bool sent, ) = recipient.call{value: amount}("");
        require(sent, "ETH transfer failed");

        emit Withdrawal(recipient, amount, authId);
    }
}
