import React from 'react'
import FirstComponentLandingPage from '../components/FirstComponentLandingPage'

const Home = () => {
    return (
        <div style={{ display: 'flex', flexDirection: 'column', gap: '2rem' }}>
            <FirstComponentLandingPage />
        </div>
    )
}

export default Home