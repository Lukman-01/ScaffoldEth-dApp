# SupplyChain DApp

The SupplyChain DApp is a decentralized application (dApp) built on the Ethereum blockchain. It aims to revolutionize supply chain management by providing transparency, immutability, and efficiency. This dApp facilitates tracking and verifying the provenance, authenticity, and quality of products throughout the supply chain.

## Getting Started

These instructions will guide you through the setup, installation, local testing, and deployment of the SupplyChain DApp on the Sepolia test network.

### Prerequisites

Before beginning the setup process, ensure you have the following tools and extensions installed on your system:

- Node.js (version 18.17 or higher)
- Yarn (version 1 or 2+)
- Git
- MetaMask or a similar Ethereum wallet browser extension

### Installation

Follow these steps to clone the repository and install the necessary dependencies:

1. **Clone the Repository:**

   ```bash
   git clone https://github.com/Lukman-01/ScaffoldEth-dApp.git
   cd ScaffoldEth-dApp
   ```

2. **Install Dependencies:**

   ```bash
   yarn install
   ```

   This command installs all the dependencies listed in the `package.json` file.

## Deploying to the Sepolia Test Network

To deploy your dApp to the Sepolia test network, follow these steps:

1. **Configure Environment Variables:**

   Set up the required environment variables in a `.env` file in the project root:

   ```
   ALCHEMY_API_KEY=your_alchemy_api_key_here
   DEPLOYER_PRIVATE_KEY=your_wallet_private_key_here
   ETHERSCAN_API_KEY=your_etherscan_api_key_here
   ```

2. **Configure Your Ethereum Wallet:**

   Ensure your MetaMask or other Ethereum wallet is connected to the Sepolia test network.

3. **Acquire Test Ether for Sepolia:**

   Get test Ether from a faucet to cover transaction fees on the Sepolia network.

4. **Deploy to Sepolia:**

   ```bash
   yarn deploy --network sepolia
   ```

   This command deploys your smart contracts to the Sepolia test network.

## Starting the Application

After deployment, you can start the NextJS application to interact with your smart contracts:

```bash
yarn start
```

Access the application at `http://localhost:3000` and explore the functionalities of your dApp.