// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

import {Script} from "forge-std/Script.sol";
import {Sweepstake} from "../src/Sweepstake.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeploySweepstake is Script {
    function run() external returns (Sweepstake, HelperConfig) {
        HelperConfig helperConfig = new HelperConfig();

        (
            address ProtocolMaintainanceFeeAddress,
            address charityDonationFeeAddress,
            uint256 interval,
            address vrfCoordinatorV2,
            bytes32 keyHash,
            uint64 subId,
            uint32 callbackGasLimit
        ) = helperConfig.activeNetworkConfig();

        vm.startBroadcast();
        Sweepstake sweepstake = new Sweepstake(
            ProtocolMaintainanceFeeAddress,
            charityDonationFeeAddress,
            interval,
            vrfCoordinatorV2,
            keyHash,
            subId,
            callbackGasLimit
        );
        vm.stopBroadcast();
        return (sweepstake, helperConfig);
    }
}
