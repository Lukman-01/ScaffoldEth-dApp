// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title SupplyChain
 * @dev A smart contract for managing a supply chain system.
 */
contract YourContract {
    uint32 public product_id = 0;  // Tracks the ID of the products in the supply chain
    uint32 public participant_id = 0;  // Tracks the ID of the participants in the supply chain
    uint32 public owner_id = 0;  // Tracks the ID of the ownerships in the supply chain

    /**
     * @dev Struct to store product information.
     */
    struct Product {
        string modelNumber;  // Model number of the product
        string partNumber;  // Part number of the product
        string serialNumber;  // Serial number of the product
        address productOwner;  // Address of the current owner of the product
        uint32 cost;  // Cost of the product
        uint32 mfgTimeStamp;  // Manufacturing timestamp of the product
    }

    /**
     * @dev Mapping to store products.
     */
    mapping(uint32 => Product) public products;  // Associates product IDs with their corresponding Product struct

    /**
     * @dev Struct to store participant information.
     */
    struct Participant {
        string userName;  // Username of the participant
        string password;  // Password of the participant
        string participantType;  // Type of participant (e.g., Manufacturer, Supplier, Consumer)
        address participantAddress;  // Ethereum address of the participant
    }

    /**
     * @dev Mapping to store participants.
     */
    mapping(uint32 => Participant) public participants;  // Associates participant IDs with their corresponding Participant struct

    /**
     * @dev Struct to store ownership information.
     */
    struct Ownership {
        uint32 productId;  // ID of the product
        uint32 ownerId;  // ID of the owner
        uint32 trxTimeStamp;  // Timestamp of the ownership transfer
        address productOwner;  // Address of the current owner of the product
    }

    /**
     * @dev Mapping to store ownerships and product track.
     */
    mapping(uint32 => Ownership) public ownerships;  // Associates ownership IDs with their corresponding Ownership struct
    mapping(uint32 => uint32[]) public productTrack;  // Associates product IDs with an array of ownership IDs representing the product's ownership history

    /**
     * @dev Event to signal ownership transfer.
     */
    event TransferOwnership(uint32 productId);  // Event emitted when ownership of a product is transferred

    /**
     * @dev Function to add a participant to the supply chain.
     * @param _name The username of the participant.
     * @param _pass The password of the participant.
     * @param _pAdd The Ethereum address of the participant.
     * @param _pType The type of participant (e.g., Manufacturer, Supplier, Consumer).
     * @return The ID of the newly added participant.
     */
    function addParticipant(
        string memory _name,
        string memory _pass,
        address _pAdd,
        string memory _pType
    ) public returns (uint32) {
        uint32 userId = participant_id++;  // Generate new participant ID

        participants[userId] = Participant({
            userName: _name,
            password: _pass,
            participantAddress: _pAdd,
            participantType: _pType
        });  // Create a new participant and store their information

        return userId;  // Return the participant ID
    }

    /**
     * @dev Function to retrieve participant details.
     * @param _participant_id The ID of the participant.
     * @return The username, Ethereum address, and participant type of the participant.
     */
    function getParticipant(uint32 _participant_id) public view returns (string memory, address, string memory) {
        Participant memory p = participants[_participant_id];  // Retrieve the participant based on their ID
        return (p.userName, p.participantAddress, p.participantType);  // Return the participant details
    }

    /**
     * @dev Function to add a product to the supply chain.
     * @param _ownerId The ID of the participant who is the owner of the product.
     * @param _modelNumber The model number of the product.
     * @param _partNumber The part number of the product.
     * @param _serialNumber The serial number of the product.
     * @param _productCost The cost of the product.
     * @return The ID of the newly added product.
     */
    function addProduct(
        uint32 _ownerId,
        string memory _modelNumber,
        string memory _partNumber,
        string memory _serialNumber,
        uint32 _productCost
    ) public returns (uint32) {
        require(
            keccak256(bytes(participants[_ownerId].participantType)) == keccak256(bytes("Manufacturer")),
            "Only a Manufacturer can add a product"
        );  // Only a participant with the participant type "Manufacturer" can add a product

        uint32 productId = product_id++;  // Generate new product ID

        Product storage p = products[productId];  // Create a new product and store its information
        p.modelNumber = _modelNumber;
        p.partNumber = _partNumber;
        p.serialNumber = _serialNumber;
        p.cost = _productCost;
        p.productOwner = participants[_ownerId].participantAddress;
        p.mfgTimeStamp = uint32(block.timestamp);

        return productId;  // Return the product ID
    }

    /**
     * @dev Function to retrieve product details.
     * @param _productId The ID of the product.
     * @return The model number, part number, serial number, cost, owner address, and manufacturing timestamp of the product.
     */
    function getProduct(uint32 _productId) public view returns (string memory, string memory, string memory, uint32, address, uint32) {
        Product memory p = products[_productId];  // Retrieve the product based on its ID
        return (p.modelNumber, p.partNumber, p.serialNumber, p.cost, p.productOwner, p.mfgTimeStamp);  // Return the product details
    }

    /**
     * @dev Function to transfer ownership of a product to a new participant.
     * @param _user1Id The ID of the current owner of the product.
     * @param _user2Id The ID of the new owner of the product.
     * @param _prodId The ID of the product to transfer ownership.
     * @return A boolean indicating whether the ownership transfer was successful.
     */
    function newOwner(uint32 _user1Id, uint32 _user2Id, uint32 _prodId) public returns (bool) {
        require(
            msg.sender == products[_prodId].productOwner,
            "Only the owner can perform this action"
        );  // Only the owner of the product can transfer ownership

        Participant memory p1 = participants[_user1Id];  // Retrieve the participants involved in the ownership transfer
        Participant memory p2 = participants[_user2Id];

        require(
            keccak256(bytes(p1.participantType)) == keccak256(bytes("Manufacturer")) &&
            (keccak256(bytes(p2.participantType)) == keccak256(bytes("Supplier")) ||
            keccak256(bytes(p2.participantType)) == keccak256(bytes("Consumer"))),
            "Invalid ownership transfer"
        );  // Validate the ownership transfer: The current owner must be a Manufacturer, and the new owner must be a Supplier or Consumer

        uint32 ownership_id = owner_id++;  // Generate a new ownership ID

        ownerships[ownership_id] = Ownership({  // Update ownership information and product owner
            productId: _prodId,
            productOwner: p2.participantAddress,
            ownerId: _user2Id,
            trxTimeStamp: uint32(block.timestamp)
        });
        products[_prodId].productOwner = p2.participantAddress;

        productTrack[_prodId].push(ownership_id);  // Add the ownership ID to the product track

        emit TransferOwnership(_prodId);  // Emit the TransferOwnership event

        return true;  // Return true to indicate a successful ownership transfer
    }

    /**
     * @dev Function to retrieve the product track (ownership history) of a product.
     * @param _prodId The ID of the product.
     * @return An array of ownership IDs representing the product track.
     */
    function getProvenance(uint32 _prodId) public view returns (uint32[] memory) {
        return productTrack[_prodId];  // Return the array of ownership IDs representing the product track
    }

    /**
     * @dev Function to retrieve ownership details.
     * @param _regId The ID of the ownership.
     * @return The product ID, owner ID, owner address, and timestamp of the ownership.
     */
    function getOwnership(uint32 _regId) public view returns (uint32, uint32, address, uint32) {
        Ownership memory o = ownerships[_regId];  // Retrieve the ownership based on its ID
        return (o.productId, o.ownerId, o.productOwner, o.trxTimeStamp);  // Return the ownership details
    }

    /**
     * @dev Function to authenticate a participant.
     * @param _uid The ID of the participant.
     * @param _uname The username of the participant.
     * @param _pass The password of the participant.
     * @param _utype The participant type.
     * @return A boolean indicating whether the participant is authenticated.
     */
    function authenticateParticipant(
        uint32 _uid,
        string memory _uname,
        string memory _pass,
        string memory _utype
    ) public view returns (bool) {
        Participant memory p = participants[_uid];  // Retrieve the participant based on their ID

        // Check if the participant's details match the provided parameters
        return (
            keccak256(bytes(p.participantType)) == keccak256(bytes(_utype)) &&
            keccak256(bytes(p.userName)) == keccak256(bytes(_uname)) &&
            keccak256(bytes(p.password)) == keccak256(bytes(_pass))
        );
    }
}