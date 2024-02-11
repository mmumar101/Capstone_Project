import React, { useState } from 'react'

const PurchaseTicket = () => {
  const [selectedNumber, setSelectedNumber] = useState('');
  const [selectedOption, setSelectedOption] = useState('');
  const [donationAmount, setDonationAmount] = useState(0);


  // ######## HANDLE CHANGE FOR DROPDOWN NUMBER ###########
  const handleChange = (e) => {
    setSelectedNumber(parseInt(e.target.value));
  };

  // ######## USING FORLOOP TO GENERATE NUMBER FROM 1 - 100 ################
  const numberOptions = [];
  for (let i = 1; i <= 100; i++) {
    numberOptions.push(<option key={i} value={i}>{i}</option>);
  }

  // ####### FUNTION TO HANDLE SELECT ##########
  const handleSelect = (e) => {
    setSelectedOption(e.target.value)
  };

  // ########## FUNCTION FOR TOTAL COST OF TICKETS ##########
  const ticketPrice = 5; 

  const calculateTotalCost = () => {
    if (!selectedNumber) return 0;
    return selectedNumber * ticketPrice;
  };
  
// ############ FUNCTION TO HANDLE DONATION ############
const handleDonationChange = (e) => {
  setDonationAmount(parseFloat(e.target.value));
};


  return (
    <div>
      <h3>Purchase Tickets</h3>
      <div style={{display:'flex'}}>
      <div style={{}}>

      {/* ########### NUMBER OF TICKETS TO PURCHASE DROPDOWN ############## */}
        <div>
          <lebel htmlFor = 'number-select'>Enter the number of tickets you wish to purchase: </lebel>
            <select id='number-select' value={selectedNumber} onChange={handleChange}>
              {numberOptions}
            </select>
            <p>You Selected: {selectedNumber}</p>
         </div>

      {/* ########### CURRENCY SELECTION DROPDOWN ################# */}
          <div>
            <label htmlFor='dropdown'>Select your preferred currency:</label>
            <select id='dropdown' value={selectedOption} onChange={handleSelect} >
              <option value='ETH'>ETH</option>
              <option value='USDC'>USDC</option>
              <option value={'USDT'}>USDT</option>
            </select>
             <p>You Selected: {selectedOption}</p>
        
          </div>

          <h3>Ticket Price: $5 each</h3>
          <p>Total Cost:$ {calculateTotalCost()}</p>

          <button>Confrim Purchase</button>

      </div>
        
      <div>
        <h3>Would you like to donate to charity?</h3>
          {/* <label htmlFor='donation-slider'>Would you like to donate to charity?</label> */}
          
          <p>Slider: Adjust Donation Amount <input
            type='range'
            id='donation-slider'
            min='0'
            max='100'
            step='1'
            value={donationAmount}
            onChange={handleDonationChange}
          /> [{donationAmount}%]</p>
        </div>

      </div>

    </div>
  )
}

export default PurchaseTicket