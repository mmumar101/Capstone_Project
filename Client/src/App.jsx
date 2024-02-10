import './App.css'
import { Routes, Route } from 'react-router-dom';
import Home from './pages/Home';
import ResponsiveAppBar from './components/Navbar'
import Result from './pages/Result';

function App() {

  return (
    <div>
      <ResponsiveAppBar />
      <Routes>
        <Route path="/" element={<Home />} />
        <Route path='/results' element={<Result />} ></Route>
      </Routes>
    </div>
  )
}

export default App
