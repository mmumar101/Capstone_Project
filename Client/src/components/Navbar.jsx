import * as React from 'react';
import AppBar from '@mui/material/AppBar';
import Box from '@mui/material/Box';
import Toolbar from '@mui/material/Toolbar';
import Typography from '@mui/material/Typography';
import Container from '@mui/material/Container';
import Button from '@mui/material/Button';
import Logo from "../images/Logo.jpg";
import { Link } from 'react-router-dom';
import { useSDK } from '@metamask/sdk-react';
import { useState } from 'react';
import { MetaMaskButton } from "@metamask/sdk-react-ui";
import { ethers } from "ethers";


function ResponsiveAppBar() {
  const { sdk, connected, connecting, provider, chainId } = useSDK();
  const [account, setAccount] = useState('');

  const connect = async () => {
    try {
      const accounts = await sdk?.connect();
      setAccount(accounts?.[0]);

    } catch (err) {
      console.warn(`failed to connect..`, err);
    }
  };

  return (
    <AppBar position="static" style={{ backgroundColor: '#242424' }}>
      <Container maxWidth="xl">
        <Toolbar disableGutters>
          <Link to="/" style={{ textDecoration: 'none' }}>
            <div style={{ display: 'flex', paddingLeft: '8rem', gap: '1rem' }} >
              <img height={35} width={35} src={Logo} alt="ReviFi Logo" ></img>
              <Typography
                variant="h6"
                noWrap
                component="a"
                sx={{
                  mr: 2,
                  display: { xs: 'none', md: 'flex' },
                  color: 'white',
                  fontFamily: 'monospace',
                  fontWeight: 700,
                  textDecoration: 'none',
                }}
              >TrustBet&nbsp;<div style={{ color: 'chartreuse' }}>SweptStake</div>
              </Typography>
            </div>
          </Link>
          <Box sx={{ flexGrow: 1, display: { xs: 'none', md: 'flex' }, gap: '1.5rem', paddingLeft: '6rem' }}>
            <Link to="/" style={{ textDecoration: 'none' }}>
              <Button
                sx={{ my: 2, color: 'white', display: 'block', border: '1px solid chartreuse' }}
              >
                Home
              </Button>
            </Link>
            <Link to="purchase-ticket" style={{ textDecoration: 'none' }}>
              <Button
                sx={{ my: 2, color: 'white', display: 'block', border: '1px solid chartreuse' }}
              >
                Purchase Ticket
              </Button>
            </Link>
            <Link to="results" style={{ textDecoration: 'none' }}>
              <Button
                sx={{ my: 2, color: 'white', display: 'block', border: '1px solid chartreuse' }}
              >
                Results
              </Button>
            </Link>
            <Link to="/governance" style={{ textDecoration: 'none' }}>
              <Button
                sx={{ my: 2, color: 'white', display: 'block', border: '1px solid chartreuse' }}
              >
                Governance
              </Button>
            </Link>
          </Box>

          <div style={{ display: 'flex', gap: '2rem' }}>
            <Button sx={{ color: '#FFFFFF', border: '1px solid chartreuse' }}
              onClick={connect}
            >
              {connected && (
                <div>
                  {account && `Connected account: ${account.slice(0, 6)}...${account.slice(-4)}`}
                </div>
              )}
            </Button>

          </div>
        </Toolbar>
      </Container>
    </AppBar>
  );
}
export default ResponsiveAppBar;
