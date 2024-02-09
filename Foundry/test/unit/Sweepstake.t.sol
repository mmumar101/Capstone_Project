// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {DeploySweepstake} from "../../script/DeploySweepstake.s.sol";
import {HelperConfig} from "../../script/HelperConfig.s.sol";
import {Sweepstake} from "../../src/Sweepstake.sol";
import {Test, console} from "forge-std/Test.sol";

contract SweepstakeTest is Test {
    // events for testing
    event SweepstakeEntered(address[] indexed newPlayer);

    Sweepstake public sweepstake;
    DeploySweepstake public deploySweepstake;
    HelperConfig helperConfig;
    uint256 public entranceFee = 0.01 ether;
    address playerOne = address(1);
    address playerTwo = address(2);
    address playerThree = address(3);
    address playerFour = address(4);
    address playerFive = address(5);
    uint256 public constant STARTING_USER_BALANCE = 10 ether;

    address ProtocolMaintainanceFeeAddress;
    address charityDonationFeeAddress;
    uint256 interval;
    address vrfCoordinatorV2;
    bytes32 keyHash;
    uint64 subId;
    uint32 callbackGasLimit;

    function setUp() external {
        deploySweepstake = new DeploySweepstake();
        (sweepstake, helperConfig) = deploySweepstake.run();
        vm.deal(playerOne, STARTING_USER_BALANCE);
        (
            ProtocolMaintainanceFeeAddress,
            charityDonationFeeAddress,
            interval,
            vrfCoordinatorV2,
            keyHash,
            subId,
            callbackGasLimit
        ) = helperConfig.activeNetworkConfig();
    }

    function testSweepstakeInitializesInOpenState() public view {
        assert(sweepstake.getState() == Sweepstake.SweepstakeState.OPEN);
    }

    function testCantEnterWithoutPaying() public {
        address[] memory players = new address[](1);
        players[0] = playerOne;
        vm.expectRevert(Sweepstake.Sweepstake__NotEnoughFeeToEnterSweepstake.selector);
        sweepstake.enterSweepstake(players);
    }

    function testSweepstakeRecordsPlayersWenTheyEnter() public {
        address[] memory players = new address[](2);
        players[0] = playerOne;
        players[1] = playerTwo;
        // vm.prank(playerOne);
        sweepstake.enterSweepstake{value: entranceFee * 2}(players);
        assertEq(sweepstake.s_players(0), playerOne);
        assertEq(sweepstake.s_players(1), playerTwo);
    }

    modifier playersEntered() {
        address[] memory players = new address[](4);
        players[0] = playerOne;
        players[1] = playerTwo;
        players[2] = playerThree;
        players[3] = playerFour;
        sweepstake.enterSweepstake{value: entranceFee * 4}(players);
        _;
    }

    function testEmitsEventOnEntrance() public {
        address[] memory players = new address[](4);
        players[0] = playerOne;
        players[1] = playerTwo;
        players[2] = playerThree;
        players[3] = playerFour;
        vm.expectEmit(true, false, false, false); // first 3 will be var and last one will be data
        emit SweepstakeEntered(players);
        sweepstake.enterSweepstake{value: entranceFee * 4}(players);
    }

    function testCantnotEnterSweepstakeIfCalculating() public playersEntered {
        vm.warp(block.timestamp + interval + 1);
        vm.roll(block.number + 1);
        sweepstake.performUpkeep("");

        vm.expectRevert(Sweepstake.Sweepstake__SweepstakeNotOpen.selector);
        sweepstake.enterSweepstake{value: entranceFee}(new address[](1));
    }
}
