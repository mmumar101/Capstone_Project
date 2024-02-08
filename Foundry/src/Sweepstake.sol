// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {VRFCoordinatorV2Interface} from "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import {AutomationCompatibleInterface} from "@chainlink/contracts/src/v0.8/interfaces/AutomationCompatibleInterface.sol";
import {VRFConsumerBaseV2} from "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";

/**
 * @title Sweepstake Contract
 * @author Capstone Project | Defi Talents
 * @notice This contract is defining Sweepstake contract. The protocol should do the following:
 * 1. EnterRaffle function to enter the raffle to win the prize pool.
 * 2. Duplicate address's are not allowed
 * 3. Users are allowed to get a refund of their ticket & valuw if they call the `refund` function
 * 4. Every X seconds, the raffle will be able to draw a winner and and send the winning prize pool to the winner.
 * 5. The Prize pool will be 90% of the total value of the raffle and rest will be the fees for the protocol's owner.
 * 6. The owner of the protocol will set a fee.
 * 7. ETH/USDC will be used as the currency for the raffle.
 * 8. small element to charity donate
 * 9. What if a person using 100 different address entered into the raffle then have more than 50% chance to win the raffle.
 * 10. Using chailink VRF and Automation for random number and winner selection respectivily.
 */
contract Sweepstake is VRFConsumerBaseV2 {
    /* Errors */

    error Sweepstake__NotEnoughFeeToEnterSweepstake();
    error Sweepstake__DuplicatePlayer();
    error Sweepstake__onlyPlayerCanRefund();
    error Sweepstake__playerAddressInvalid();
    error Sweepstake__SweepstakeNotOpen();
    error Sweepstake__TransferFailed();
    error Sweepstake__SweepstakeNotOver();

    /* Type Declarations */
    enum SweepstakeState {
        OPEN,
        CALCULATING
    }
    /* State variables */

    address payable[] private s_players;
    uint256 public immutable i_interval;
    uint256 public s_sweepstakeStartTime;
    address public recentWinner;
    uint256 public immutable entranceFee;
    address public feeAddress;
    uint256 public totalFees = address(this).balance;
    uint256 public winnerPrice = totalFees * (80 / 100);
    uint256 public charityDonation = totalFees * (10 / 100);
    uint256 public protocolMaintainance = totalFees * (10 / 100);
    //enum
    SweepstakeState private s_sweepstakeState;

    // randome generator
    bytes32 private immutable i_keyHash;
    uint64 private immutable i_subId;
    uint16 private constant MINIMUM_REQUEST_CONFIRMATION = 3;
    uint32 private immutable i_callbackGasLimit;
    uint32 private constant NUM_WORDS = 1;

    // Chainlink VRF Variables
    VRFCoordinatorV2Interface private immutable i_vrfCoordinator;

    // event RaffleEnter(address[] newPlayers);
    // event RaffleRefunded(address player);
    // event FeeAddressChanged(address newFeeAddress);

    constructor(
        uint256 _entranceFee,
        address _feeAddress,
        uint256 _interval,
        address vrfCoordinatorV2,
        bytes32 keyHash,
        uint64 subId,
        uint32 callbackGasLimit
    ) VRFConsumerBaseV2(vrfCoordinatorV2) {
        i_keyHash = keyHash;
        i_subId = subId;
        i_callbackGasLimit = callbackGasLimit;
        entranceFee = _entranceFee;
        feeAddress = _feeAddress;
        i_interval = _interval;
        s_sweepstakeStartTime = block.timestamp;
        s_sweepstakeState = SweepstakeState.OPEN;
    }

    function enterRaffle() public payable {} //

    /* Helps in checking all the states whether true or falls, if true then only perform upkeep func will get get executed  */
    function checkUpkeep(bytes memory /* checkData */ )
        public
        view
        override
        returns (bool upkeepNeeded, bytes memory /* performData */ )
    {}

    /* Once `checkUpkeep` is returning `true`, this function is called and it kicks off a Chainlink VRF call to get a random winner */
    function performUpkeep(bytes calldata /* performData */ ) external override {
        uint256 requestId = i_vrfCoordinator.requestRandomWords(
            i_keyHash, i_subId, MINIMUM_REQUEST_CONFIRMATION, i_callbackGasLimit, NUM_WORDS
        );
    }

    /*  */
    function fulfillRandomWords(uint256 requestId, uint256[] memory randomWords) internal override {
        require(msg.sender != recentWinner, "Cannot do reentrancy");
        uint256 indexOfWinner = randomWords[0] % s_players.length;
        address payable winner = s_players[indexOfWinner];
        recentWinner = winner;
        (bool success,) = winner.call{value: winnerPrice}("");
        if (!success) {
            revert Sweepstake__TransferFailed();
        }
    }

    function pickWinner() public {} //
    function withdrawFees() external {}
    //
    function refund(uint256 playerIndex) public {}
    //
    function changeFeeAddress(address newFeeAddress) external {}
    //1

    function getActivePlayerIndex(address player) external view returns (uint256) {} //
}
