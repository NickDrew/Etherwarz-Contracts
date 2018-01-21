import React from 'react';
import { Link } from 'react-router';

const botdata = {
    '60203103100000030200520101090611': {
      'name': 'S211-Flea',
      'botClass': 'Scout',
      'speed': '9',
      'power': '6',
      'armour': '11',
      'imglink': ''
    },
    '70204204200000030231220104130910': {
        'name': 'S222-Uzeil',
        'botClass': 'Scout',
        'speed': '13',
        'power': '9',
        'armour': '10',
        'imglink': ''
    },
    '40507407200000020550020103111416': {
        'name': 'B541-Mauler',
        'botClass': 'Bombard',
        'speed': '11',
        'power': '14',
        'armour': '16',
        'imglink': ''
    },
    '40505205200000020506020101061614': {
        'name': 'B522-Shadow Cat',
        'botClass': 'Bombard',
        'speed': '6',
        'power': '16',
        'armour': '14',
        'imglink': ''
    },
    '50509309300000020532120104102017': {
        'name': 'B533-Fafnir',
        'botClass': 'Bombard',
        'speed': '10',
        'power': '20',
        'armour': '17',
        'imglink': ''
    },
    '20707407200000010700620101031426': {
        'name': 'A742-Thanatos',
        'botClass': 'Assault',
        'speed': '3',
        'power': '14',
        'armour': '26',
        'imglink': ''
    },
    '30706906900000010713220105051534': {
    'name': 'A799-Mjolnir',
    'botClass': 'Assault',
    'speed': '5',
    'power': '15',
    'armour': '34',
    'imglink': ''
    }
  };

  

 export default class Bot extends React.Component {
     render(){
         const name = botdata[this.props.lineID].name;
         const botClass = botdata[this.props.lineID].botClass;
         const speed = botdata[this.props.lineID].speed;
         const power = botdata[this.props.lineID].power;
         const armour = botdata[this.props.lineID].armour;
         const imglink = botdata[this.props.lineID].imglink;
         return(
            <span className="bot">
            <div className="name">{name}</div>
            <img className="image" src={imglink}/>
            <div></div>
          </span>
         );
     }
 }