import React, { Component } from 'react'

class War extends Component {
  constructor(props, { authData }) {
    super(props)
    authData = this.props
  }

  render() {
    return(
      <main className="container">
        <div className="pure-g">
          <div className="pure-u-1-1">
            <h1>WAR!</h1>
            <p>Welcome to WAR!</p>
          </div>
        </div>
      </main>
    )
  }
}

export default War
