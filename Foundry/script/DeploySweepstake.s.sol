// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Script} from "forge-std/Script.sol";
import {Sweepstake} from "../src/Sweepstake.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeploySweepstake is Script {
    function run() external returns (Sweepstake) {
        HelperConfig helperConfig = new HelperConfig();

        (
            uint256 entranceFee,
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
            entranceFee,
            ProtocolMaintainanceFeeAddress,
            charityDonationFeeAddress,
            interval,
            vrfCoordinatorV2,
            keyHash,
            subId,
            callbackGasLimit
        );
        vm.stopBroadcast();
        return sweepstake;
    }
}
