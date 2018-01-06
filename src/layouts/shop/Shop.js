import React, { Component } from 'react'

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
            <p>Welcome to the Shop</p>
          </div>
        </div>
      </main>
    )
  }
}

export default Shop
