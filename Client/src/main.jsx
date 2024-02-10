import ReactDOM from 'react-dom/client'
import App from './App.jsx'
import './index.css'
import { BrowserRouter } from 'react-router-dom';
import AuthProvider from './Providers/auth.jsx';
import { MetaMaskProvider } from '@metamask/sdk-react';

ReactDOM.createRoot(document.getElementById('root')).render(
  <BrowserRouter>
    <MetaMaskProvider debug={false} sdkOptions={{
      dappMetadata: {
        name: "TrustBet SweptStake",
        url: window.location.href,
      }
    }}>
      <AuthProvider>
        <App />
      </AuthProvider>
    </MetaMaskProvider>
  </BrowserRouter>
)
