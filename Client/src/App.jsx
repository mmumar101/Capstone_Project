import './App.css'
import { Routes, Route } from 'react-router-dom';
import Home from './pages/Home';
import ResponsiveAppBar from './components/Navbar'
import Result from './pages/Result';
import Governance from './pages/Governance';
import PurchaseTicket from './pages/PurchaseTicket';

function App() {

  return (
    <div>
      <ResponsiveAppBar />
      <Routes>
        <Route path="/" element={<Home />} />
        <Route path='/results' element={<Result />} />
        <Route path='/governance' element={<Governance />} />
        <Route path='/purchase-ticket' element={<PurchaseTicket />} />

      </Routes>
    </div>
  )
}

export default App
