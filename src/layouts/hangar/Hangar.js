import React, { Component } from 'react'
import OwnershipContract from '../../../build/contracts/SmartDroneOwnership.json'
import { browserHistory } from 'react-router'
import store from '../../store'

const contract = require('truffle-contract')

class Hangar extends Component {
  render() {
    return(
      <main className="container">
        <div>EtherWarz</div>
      </main>
    )
  }
}

export default Hangar
