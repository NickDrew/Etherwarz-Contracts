import React, { Component } from 'react'
import SmartDroneCoreContract from '../../build/contracts/SmartDroneCore.json'
import { browserHistory } from 'react-router'
import store from '../store'

const contract = require('truffle-contract')

export function LiveAuctions() {
    let web3 = store.getState().web3.web3Instance

      // Double-check web3's status.
  if (typeof web3 !== 'undefined') {
      return function(dispatch) {

        // Using truffle-contract we create the core object.
        const smartDroneCore = contract(SmartDroneCoreContract)
        smartDroneCore.setProvider(web3.currentProvider)

        // Declaring this for later so we can chain functions on Authentication.
        var smartDroneCoreInstance

        // Get current ethereum wallet.
        web3.eth.getCoinbase((error, coinbase) => {
        // Log errors, if any.
        if (error) {
          console.error(error);
        }
        
        smartDroneCore.deployed().then(function(instance){
            smartDroneCoreInstance = instance


        })

      })
    }
  } else {
      console.error('Web3 is not initialised');
  }
}