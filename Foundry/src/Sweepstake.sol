// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {VRFCoordinatorV2Interface} from "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import {AutomationCompatibleInterface} from "@chainlink/contracts/src/v0.8/interfaces/AutomationCompatibleInterface.sol";
import {VRFConsumerBaseV2} from "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";

/**
 * @title Sweepstake Contract
 * @author Capstone Project | Defi Talents
 * @notice This contract is defining Sweepstaking contract. The protocol should do the following:
 * 1. Enter Sweepstake function to enter the Sweepstake to win the prize pool.
 * 2. Duplicate address's are not allowed
 * 3. Users are allowed to get a refund of their ticket & value if they call the `refund` function
 * 4. Every X seconds, the Sweepstake will be able to draw a winner and and send the winning prize pool to the winner.
 * 5. The Prize pool will be 90% of the total value of the Sweepstake and rest will be the fees for the protocol's owner.
 * 6. The owner of the protocol will set a fee.
 * 7. ETH/USDC will be used as the currency for the Sweepstake.
 * 8. small element to charity donate
 * 9. What if a person using 100 different address entered into the Sweepstake then have more than 50% chance to win the Sweepstake.
 * 10. Using chailink VRF, Automation and Agreegator for random number, automatic winner selection and Price Conversion respectivily.
 */
contract Sweepstake is VRFConsumerBaseV2, AutomationCompatibleInterface {
    /* Errors */
    error Sweepstake__NotEnoughFeeToEnterSweepstake();
    error Sweepstake__DuplicatePlayer();
    error Sweepstake__OnlyPlayerCanRefund();
    error Sweepstake__PlayerAddressInvalid();
    error Sweepstake__SweepstakeNotOpen();
    error Sweepstake__TransferFailed();
    error Sweepstake__SweepstakeNotOver();
    error Sweepstake__UpkeepNotNeeded(uint256 sweepstakeState, uint256 numPlayers, uint256 currentBal);
    error Sweepstake__PriceAlreadyDistributed();
    error Not_ProtocolMaintainanceFeeAddress();
    error Sweepstake__CannotRefund();

    /* Type Declarations */
    enum SweepstakeState {
        OPEN,
        CALCULATING
    }

    mapping(address => uint256) public addressToSweepsatkeId;

    /* State variables */
    address payable[] public s_players;
    uint256 public immutable i_interval;
    uint256 public s_sweepstakeStartTime;
    address public s_recentWinner;
    uint256 public immutable i_entranceFee;
    uint256 public totalFees = address(this).balance;
    uint256 public winnerPrice = (totalFees * 80) / 100;
    uint256 public charityDonation = (totalFees * 10) / 100;
    uint256 public protocolMaintainance = (totalFees * 10) / 100;
    address public s_charityDonationFeeAddress;
    address public s_ProtocolMaintainanceFeeAddress;
    SweepstakeState private s_sweepstakeState;
    uint256 public sweepstakeId = 0;

    // randome generator
    bytes32 private immutable i_keyHash;
    uint64 private immutable i_subId;
    uint16 private constant MINIMUM_REQUEST_CONFIRMATION = 3;
    uint32 private immutable i_callbackGasLimit;
    uint32 private constant NUM_WORDS = 1;

    // Chainlink VRF Variables
    VRFCoordinatorV2Interface private immutable i_vrfCoordinator;

    /* Events */
    event SweepstakeEntered(address payable[] newPlayer);
    event SweepstakeRefunded(address player);
    event FeeAddressChanged(address newFeeAddress);
    event RequestedSweepstakeWinner(uint256 indexed requestId);
    event RefundAddress(address indexed refunded);

    constructor(
        uint256 _entranceFee,
        address _ProtocolMaintainanceFeeAddress,
        address _charityDonationFeeAddress,
        uint256 _interval,
        address vrfCoordinatorV2,
        bytes32 keyHash,
        uint64 subId,
        uint32 callbackGasLimit
    ) VRFConsumerBaseV2(vrfCoordinatorV2) {
        i_keyHash = keyHash;
        i_subId = subId;
        i_callbackGasLimit = callbackGasLimit;
        i_entranceFee = _entranceFee;
        s_ProtocolMaintainanceFeeAddress = _ProtocolMaintainanceFeeAddress;
        s_charityDonationFeeAddress = _charityDonationFeeAddress;
        i_interval = _interval;
        s_sweepstakeStartTime = block.timestamp;
        s_sweepstakeState = SweepstakeState.OPEN;
    }

    function enterRaffle(address payable[] memory newPlayers) public payable {
        if (msg.value != i_entranceFee * newPlayers.length) {
            revert Sweepstake__NotEnoughFeeToEnterSweepstake();
        }
        if (SweepstakeState.OPEN != s_sweepstakeState) {
            revert Sweepstake__SweepstakeNotOpen();
        }
        for (uint256 i = 0; i < newPlayers.length; i++) {
            if (newPlayers[i] == address(0)) {
                revert Sweepstake__PlayerAddressInvalid();
            }
        }
        // Check for duplicates only from the new players
        for (uint256 i = 0; i < newPlayers.length; i++) {
            if (addressToSweepsatkeId[newPlayers[i]] != sweepstakeId) {
                revert Sweepstake__DuplicatePlayer();
            }
        }

        for (uint256 i = 0; i < newPlayers.length; i++) {
            s_players.push(newPlayers[i]);
            addressToSweepsatkeId[newPlayers[i]] = sweepstakeId;
        }
        emit SweepstakeEntered(newPlayers);
    }

    /* Helps in checking all the states whether true or falls, if true then only perform upkeep func will get get executed  */
    function checkUpkeep(bytes memory /* checkData */ )
        public
        view
        override
        returns (bool upkeepNeeded, bytes memory /* performData */ )
    {
        bool sweepstakeIsOpen = SweepstakeState.OPEN == s_sweepstakeState;
        bool intervalHasPassed = block.timestamp - s_sweepstakeStartTime > i_interval;
        bool havePlayers = s_players.length > 0;
        bool hasBalance = address(this).balance > 0;
        upkeepNeeded = (sweepstakeIsOpen && intervalHasPassed && havePlayers && hasBalance);
        return (upkeepNeeded, "0x0");
    }

    /* Once checkUpkeep is returning true, this function is called and it kicks off a Chainlink VRF call to get a random winner */
    function performUpkeep(bytes calldata /* performData */ ) external override {
        (bool upkeepNeeded,) = checkUpkeep("");
        if (!upkeepNeeded) {
            revert Sweepstake__UpkeepNotNeeded(uint256(s_sweepstakeState), s_players.length, address(this).balance);
        }
        uint256 requestId = i_vrfCoordinator.requestRandomWords(
            i_keyHash, i_subId, MINIMUM_REQUEST_CONFIRMATION, i_callbackGasLimit, NUM_WORDS
        );
        emit RequestedSweepstakeWinner(requestId);
    }

    /* Picking Winner */
    function fulfillRandomWords(uint256, /* requestId */ uint256[] memory randomWords) internal override {
        // Avoiding Reentrancy
        if (msg.sender == s_recentWinner) {
            revert Sweepstake__PriceAlreadyDistributed();
        }

        sweepstakeId++;
        uint256 indexOfWinner = randomWords[0] % s_players.length;
        address payable winner = s_players[indexOfWinner];
        s_recentWinner = winner;
        (bool success,) = winner.call{value: winnerPrice}("");
        if (!success) {
            revert Sweepstake__TransferFailed();
        }
    }

    function withdrawFees() external {
        if (msg.sender != s_ProtocolMaintainanceFeeAddress) {
            revert Not_ProtocolMaintainanceFeeAddress();
        }

        uint256 protocolMaintainanceFeeWithdraw = protocolMaintainance;
        protocolMaintainance = 0;

        (bool success,) = s_ProtocolMaintainanceFeeAddress.call{value: protocolMaintainanceFeeWithdraw}("");
        if (!success) {
            revert Sweepstake__TransferFailed();
        }
    }

    function getRefund(uint256 playerIndex) public {
        address payable playerAddress = s_players[playerIndex];
        if (msg.sender != playerAddress) {
            revert Sweepstake__CannotRefund();
        }
        if (playerAddress == address(0)) {
            revert Sweepstake__CannotRefund();
        }

        s_players[playerIndex] = payable(address(0));

        emit RefundAddress(playerAddress);

        (bool success,) = playerAddress.call{value: i_entranceFee}("");
        if (!success) {
            revert Sweepstake__TransferFailed();
        }
    }

    function getActivePlayerIndex(address player) external view returns (uint256) {
        for (uint256 i = 0; i < s_players.length; i++) {
            if (s_players[i] == player) {
                return i;
            }
        }
        // no such player found
        revert Sweepstake__PlayerAddressInvalid();
    }
}
