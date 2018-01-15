import React, { Component } from 'react'
import OwnershipContract from '../../../build/contracts/SmartDroneAuction.json'
import { browserHistory } from 'react-router'
import store from '../../store'
//import core from '../../util/Core'

class Shop extends Component {
  constructor(props, { authData }) {
    super(props)
    authData = this.props
  }

  render() {
    return(
      <main className="container">
        <div className="pure-g">
          <div className="pure-u-1-1">
            <h1>Shop</h1>
            <div className="botCard">
            <div className="botCardTitle">Tiger Tank</div>
              <img className="botImg" src="http://www.mybligr.com/wp-content/uploads/2017/01/most-beautiful-tiger-animals-pics-images-photos-pictures-7-300x300.jpg"/>
              </div>
          </div>
        </div>
      </main>
    )
  }
}

export default Shop
