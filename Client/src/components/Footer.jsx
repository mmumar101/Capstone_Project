import React from 'react'
import FacebookIcon from '@mui/icons-material/Facebook';
import TwitterIcon from '@mui/icons-material/Twitter';
import InstagramIcon from '@mui/icons-material/Instagram';


function Footer() {
  return (
    <div>
      <div style={{display:'flex',justifyContent:'center'}}>
        <div>
        <h5>Social Media Links:</h5>
        <div style={{display:'flex', alignItems:'center', gap:'1.5rem'}}>
          <FacebookIcon style={{}}/>
          <TwitterIcon />
          <InstagramIcon />
        </div>
        </div>

        <div style={{}}>
          <h5>Helpful Links</h5>
            <button>FAQ</button> <br />
            <button>Support</button>
        </div>

        <div >
          <h5>Disclaimer</h5>
          <p>Gambling involves risks and should be done responsibly. We encourage responsible gambling practices and advise users to gamble only what they can afford to lose.</p>
        </div>
        
      </div>
      <p>Terms of Service | Privacy Policy</p>
    </div>
  )
}

export default Footer