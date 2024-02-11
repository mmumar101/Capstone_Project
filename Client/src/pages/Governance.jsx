import React from 'react'

const Governance = () => {
  return (
    <div>
      {/* ################ INTRODUCTION ############## */}
      <h2>Welcome to Governance Page</h2>

      {/* ################ OVERVIEW ################## */}
      <p>
        Governance tokens play a vital role in shaping the future of our decentralized raffle site. They empower community members to participate in decision-making processes and influence key parameters that affect the entire ecosystem.
      </p>

      {/* voting section */}
      <div>
          <button>Vote Now</button>

          <p>
            You have the power to vote on important parameters such as:
          </p>

          <ul>
            <li>Ticket Price</li>
            <li>Prize Distribution</li>
            <li>Lottery Schedules</li>
          </ul>

          <p>
            Make your voice heard and shape the future of our platform!
         </p>

      </div>

      {/* ############### CURRENT PROPOSALS ############# */}

        <div>
            <h3>Current Proposals</h3>
            <div>
              <p>Proposal 1: Adjusting Ticket Price</p>
              <p>Status: Voting</p>
              <p>Description: We propose to adjust the ticket price to make it more accessible to a wider audience. Your input is crucial in determining the new price point.</p>
            </div>

            <div>
              <p>Proposal 2: Introducing Monthly Special Raffles</p>
              <p>Status: Pending</p>
              <p>Description: We suggest adding monthly special raffles with exclusive prizes to incentivize regular participation. Your feedback on this proposal is appreciated.</p>
            </div>

            <div>
              <span>Governance Token </span>
              <p>We encourage active participation from our community members. Your ideas and feedback are invaluable in shaping the future of our platform. Join our community forums and engage in discussions today!</p>
            </div>
          
        </div>

    </div>
  )
}

export default Governance