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

contract Sweepstake {
    /* Errors */

    error Sweepstake__NotEnoughFeeToEnterRaffle();
    error Sweepstake__DuplicatePlayer();
    error Sweepstake__onlyPlayerCanRefund();
    error Sweepstake__playerAddressInvalid();
    error Sweepstake__RaffleNotOpen();
    error Sweepstake__TransferFailed();
    error Sweepstake__RaffleNotOver();

    /* Type Declarations */
    enum RaffleState {
        OPEN,
        CALCULATING
    }
    /* State variables */

    address[] public s_players;
    uint256 public immutable i_interval;
    uint256 public s_raffleStartTime;
    address public previousWinner;
    uint256 public immutable entranceFee;
    address public feeAddress;
    uint64 public totalFees = 0;

    // randome generator
    bytes32 keyHash;
    uint64 subId;
    uint16 minimumRequestConfirmations;
    uint32 callbackGasLimit;
    uint32 numWords;

    // Chainlink VRF Variables
    VRFCoordinatorV2Interface private immutable i_vrfCoordinator;

    // event RaffleEnter(address[] newPlayers);
    // event RaffleRefunded(address player);
    // event FeeAddressChanged(address newFeeAddress);

    constructor(uint256 _entranceFee, address _feeAddress, uint256 _raffleDuration)
        VRFConsumerBaseV2(vrfCoordinatorV2)
    {}

    function enterRaffle() public payable {} //

    /* Helps in checking all the states whether true or falls, if true then only perform upkeep func will get get executed  */
    function checkUpkeep(bytes memory /* checkData */ )
        public
        view
        override
        returns (bool upkeepNeeded, bytes memory /* performData */ )
    {}

    /* Once `checkUpkeep` is returning `true`, this function is called and it kicks off a Chainlink VRF call to get a random winner */
    function performUpkeep(bytes calldata /* performData */ ) external override {}

    function pickWinner() public {} //
    function withdrawFees() external {}
    //
    function refund(uint256 playerIndex) public {}
    //
    function changeFeeAddress(address newFeeAddress) external {}
    //1

    function getActivePlayerIndex(address player) external view returns (uint256) {} //
}
