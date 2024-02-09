//SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

import {Script} from "forge-std/Script.sol";
import {VRFCoordinatorV2Mock} from "@chainlink/contracts/src/v0.8/mocks/VRFCoordinatorV2Mock.sol";

contract HelperConfig is Script {
    struct NetworkConfig {
        address ProtocolMaintainanceFeeAddress;
        address charityDonationFeeAddress;
        uint256 interval;
        address vrfCoordinatorV2;
        bytes32 keyHash;
        uint64 subId;
        uint32 callbackGasLimit;
    }

    NetworkConfig public activeNetworkConfig;

    constructor() {
        if (block.chainid == 80001) {
            activeNetworkConfig = getPolygonConfig();
        } else {
            activeNetworkConfig = getOrCreateAnvilConfig();
        }
    }

    // Testnet
    function getPolygonConfig() public view returns (NetworkConfig memory polygonNetworkConfig) {
        polygonNetworkConfig = NetworkConfig({
            ProtocolMaintainanceFeeAddress: msg.sender,
            charityDonationFeeAddress: 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266,
            interval: 180, //3min
            vrfCoordinatorV2: 0x7a1BaC17Ccc5b313516C5E16fb24f7659aA5ebed,
            keyHash: 0x4b09e658ed251bcafeebbc69400383d49f344ace09b9576fe248bb02c003fe9f,
            subId: 7111, // from vrf
            callbackGasLimit: 500000
        });
    }

    // to run anvil completely n local we need Mocks
    function getOrCreateAnvilConfig() public returns (NetworkConfig memory anvilNetworkConfig) {
        if (activeNetworkConfig.vrfCoordinatorV2 != address(0)) {
            return activeNetworkConfig;
        }
        // base fee anf gas price here is for constructor parameter of mock

        uint96 baseFee = 0.25 ether; // 0.25 LINK
        uint96 gasPriceLink = 1e9; // 1 gwei LINK

        vm.startBroadcast();
        VRFCoordinatorV2Mock vrfCoordinatorV2Mock = new VRFCoordinatorV2Mock(baseFee, gasPriceLink);
        vm.stopBroadcast();

        anvilNetworkConfig = NetworkConfig({
            ProtocolMaintainanceFeeAddress: msg.sender,
            charityDonationFeeAddress: 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266,
            interval: 180, //3min
            vrfCoordinatorV2: address(vrfCoordinatorV2Mock),
            keyHash: 0x474e34a077df58807dbe9c96d3c009b23b3c6d0cce433e59bbf5b34f823bc56c, // does not matter
            subId: 0, // script will add this
            callbackGasLimit: 500000
        });
    }
}
