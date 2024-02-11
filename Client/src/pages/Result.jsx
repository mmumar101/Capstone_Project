import React from 'react'

const Result = () => {
    return (
        <div style={{}}>
            {/* ########## RESULTS ########## */}

            <h2 className='bg-red-700'>WINNERS ANNOUNCEMENT</h2>
            <div style={{display:'flex', gap:'2rem', border:'2px', alignItems:'center'}}>
                <div>
                    <h4>Previous Raffle Winners</h4>
                    <ol>
                        <li>Winner: John Doe      Prize: $400 USDC</li>
                        <li>Winner: Smith Peter   Prize: $200 USCC</li>
                        <li>Winner: Salim Okasha  Prize: $100 USCC</li>
                    </ol>
                </div>
                <div>
                    <h4>Current Raffle Winners</h4>
                    <h5>Congratulations to the Lucky Winners</h5>
                    <ol>
                        <li>Winner: Mike Slone      Prize: $400 USDC</li>
                        <li>Winner: Edward Emmanuel   Prize: $200 USCC</li>
                        <li>Winner: Salim Okasha  Prize: $100 USCC</li>
                    </ol>
                    
                </div>
            </div>
            <h3>Claim Prize!</h3>
                    <p>If you are the lucky winner, click the button below to claim your prize!</p>
                    <button>Claim Prize</button>
        </div>
    )
}

export default Result