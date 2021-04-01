import React from 'react'
import ReactDOM from 'react-dom'
import PropTypes from 'prop-types'

import DialogueItems from "./dialogues";

class DialogueBox extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      DialogueItems: []
    }
  }
    render() {
      return (
      <DialogueItems>
        <p>Test</p>
      </DialogueItems>
      )
    }
}


document.addEventListener('DOMContentLoaded', () => {
    ReactDOM.render(
      <DialogueBox />,
      document.getElementById('results_box'),
    )
})