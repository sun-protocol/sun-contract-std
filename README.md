## Sun Contract Standard Library

This repository contains a small set of reusable Solidity utilities and patterns used in the Sun Protocol ecosystem, with a focus on TRON / TRC‑20 token handling and secure vault operations. It is set up as a dual Hardhat + Foundry project so you can both develop and test contracts conveniently.

### Features

- **`SafeTransferLib`**: Helper library for interacting with TRC‑20 / ERC‑20 tokens that may not strictly follow the standard and might not return a boolean value.
  - Wraps `approve`, `transfer`, and `transferFrom` with safe low‑level calls.
  - Contains special handling for TRON USDT contracts on:
    - **Nile testnet** (`NILE_CHAIN_ID`, `USDTNileAddr`)
    - **Mainnet** (`MAIN_CHAIN_ID`, `USDTMainAddr`)
  - Provides a `safeTransferETH` function for safely sending native TRX/ETH‑style value.

- **`SSPSafeVault`**: A simple owner‑controlled vault contract.
  - Holds a single `assetToken` (`IERC20`) and uses OpenZeppelin `SafeERC20`.
  - Supports a configurable set of `minters` that can request token transfers from the vault to recipients.
  - Allows the owner to recover:
    - Native TRX via `recoverTRX`.
    - Any TRC‑20 / ERC‑20 token via `recoverTRC20`.

- **Extensive Tests**:
  - Foundry tests in `test/` cover:
    - Standard ERC‑20 behavior.
    - Tokens that do not return a value.
    - Tokens that revert or return `false`.
    - Special cases for TRON USDT on Nile and Mainnet.

### Project Structure

- **`contracts/`**
  - `libraries/SafeTransferLib.sol` – Safe token transfer helpers with TRON USDT special cases.
  - `utils/SSPSafeVault.sol` – Owner‑controlled vault using OpenZeppelin `Ownable` and `SafeERC20`.
- **`test/`**
  - `SafeTransferLib.t.sol` – Foundry tests for `SafeTransferLib`.
  - `TokenSender.sol` – Simple helper contract used by tests to exercise the library.
  - `mocks/` – Mock ERC‑20 implementations simulating different token behaviors.
- **`foundry.toml`** – Foundry configuration pointing to `contracts/` and `test/`.
- **`hardhat.config.ts`** – Hardhat configuration (via `@sun-protocol/sunhat`) with support for TRON networks (`tron`, `nile`, `shasta`) and a local Ethereum‑style network (`localhost`).
- **`deploy/` and `deployTron/`** – Example deployment scripts for Hardhat.

### Prerequisites

- **Node.js** (v18+ recommended)
- **npm** or **yarn**
- **Foundry** (for `forge` commands) – see the Foundry book for installation instructions.

### Installation

```bash
git clone <this-repo-url>
cd sun-contract-std
npm install
```

This will install all Node dependencies, including Hardhat, `@sun-protocol/sunhat`, and OpenZeppelin contracts.

### Usage

#### Using the Library in Your Contracts

Install this package (or copy the contracts into your own project, depending on how you consume it), then:

```solidity
pragma solidity >=0.4.22 <0.9.0;

import "./contracts/libraries/SafeTransferLib.sol";

contract TokenSender {
    using SafeTransferLib for address;

    function send(address token, address to, uint256 amount) external returns (bool) {
        return token.safeTransfer(to, amount);
    }
}
```

For the vault:

```solidity
pragma solidity >=0.6.0 <0.9.0;

import "./contracts/utils/SSPSafeVault.sol";

contract MyVault is SSPSafeVault {
    constructor(address asset) SSPSafeVault(asset) {}
}
```

Adjust import paths to match how you integrate this repository (e.g. via `node_modules` or direct relative paths).

### Development

- **Compile with Hardhat**

```bash
npm run compile
```

- **Run Hardhat tests**

```bash
npm test
```

- **Run Foundry tests**

```bash
npm run test-foundry
```

Make sure you have Foundry installed and `forge` available in your `PATH`.

### Networks and Deployment

Hardhat is configured via `hardhat.config.ts` to support:

- **localhost** – Local Hardhat network (for development and testing).
- **tron** – TRON mainnet.
- **nile** – TRON Nile testnet.
- **shasta** – TRON Shasta testnet.

You can use the provided scripts as a starting point:

- **Deploy to localhost**

```bash
npm run deploy
```

- **Deploy to TRON networks**

```bash
npm run deploy-tron     # mainnet
npm run deploy-nile     # Nile testnet
npm run deploy-shasta   # Shasta testnet
```

Set the `PRIVATE_KEY` environment variable in a `.env` file or your shell before deploying to live networks.

### Security Disclaimer

These contracts are provided **as‑is** and without any warranty. They are intended as reusable primitives but may not have undergone a full professional audit. **Use at your own risk**, and always perform your own security review and testing before deploying to mainnet.

### License

This project is licensed under the **MIT License**. See the SPDX identifiers in the Solidity files for more details.

