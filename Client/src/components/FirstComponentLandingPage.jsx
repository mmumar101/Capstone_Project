import React from 'react'
import Button from '@mui/material/Button';

const FirstComponentLandingPage = () => {
    return (
        <div style={{ display: 'flex', flexDirection: 'column', paddingTop: '7rem', color: 'white' }}>
            <div style={{ display: 'flex', width: '100%', justifyContent: 'center', gap: '6rem' }}>
                <div style={{ display: 'flex', flexDirection: 'column', width: '70%' }}>
                    <h1 style={{ fontWeight: '700', fontSize: '3.75rem', lineHeight: '1' }}>TrustBet<span style={{ color: 'chartreuse' }} > SweptStake</span>
                    </h1>
                    <p style={{ fontFamily: 'sans-serif', fontSize: '1.25rem' }}> Decentralized Autonomous Raffle Lorem ipsum dolor sit amet consectetur adipisicing elit. Deleniti doloribus molestias eos dolorem facere nemo praesentium tempore adipisci quidem pariatur provident vero sit at unde dolorum, eum, officia ea maxime. Lorem ipsum dolor sit, amet consectetur adipisicing elit. Quas labore et facilis. Sint quas consectetur officia illum voluptatem. Sit dolores suscipit nesciunt aliquid minima dolore eaque aspernatur nemo ea eligendi? Lorem ipsum dolor, sit amet consectetur adipisicing elit. Consequuntur iusto officiis sed sequi eum nesciunt dolorem, debitis perspiciatis culpa blanditiis, adipisci iste nulla saepe hic, voluptas odit ipsa deserunt rerum. lorem</p>
                    <div style={{ display: 'flex', gap: '2rem', paddingTop: '4rem' }}>
                        <Button style={{ color: 'white', width: '40%', border: '1px solid chartreuse' }}>
                            Enter Raffle
                        </Button>
                    </div>
                </div>
                <div>
                </div>
            </div>
            <div style={{ display: 'flex', justifyContent: 'center', paddingTop: '6rem' }}>
            </div>
        </div>
    )
}

export default FirstComponentLandingPage;