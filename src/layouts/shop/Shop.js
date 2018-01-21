import React, { Component } from 'react'
import OwnershipContract from '../../../build/contracts/SmartDroneAuction.json'
import { browserHistory } from 'react-router'
import store from '../../store'
import botCard from '../Bot/bot'
import request from 'request'
//import core from '../../util/Core'

class Shop extends Component {
  constructor(props, { authData }) {
    super(props)
    authData = this.props
    this.state = {
      bots: [],
      nextPage: "",
      totalPages: ""
    };
    this._loadData = this._loadData.bind(this);
  }
  componentDidMount(){
    const url = 'http://localhost:1337/auctions?page=1&pagesize=5&sortby=price&sortorder=1';
    this._loadData(url);
  }
  _loadData(url){
    request.get(url).then((Response) => {
      this.setState({
        botData: Response.data,
        nextPage: Response.nextpage,
        previousPage: Response.previousPage
      });
    });
  }
  render() {
    return(
      <main className="container">
        <div className="pure-g">
          <div className="pure-u-1-1">
            <div className="Bots">
            <div>shopppp</div>
              {this.state.botData}
            </div>
          </div>
        </div>
      </main>
    )
  }
}
//{this.state.botData.map(botData => <botCard key={this.state.botData} {...this.state.botData} />)}
export default Shop
