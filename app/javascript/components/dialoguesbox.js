import React from 'react'
import ReactDOM from 'react-dom'
import axios from "axios";

import DialogueItems from "./dialogueitems";
import DialogueItem from "./dialogueitem";

class DialogueBox extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      dialogueItems: []
    };
    this.getDialogueItems = this.getDialogueItems.bind(this);
  }
  componentDidMount() {
    this.getDialogueItems();
  }
  getDialogueItems() {
    axios
      .get("/api/v1/dialogue/555")
      .then(response => {
        const dialogueItems = response.data;
        this.setState({ dialogueItems });
      })
      .catch(error=> {
        console.log(error)
      })
  }


    render() {
      return (
        <DialogueItems>
            {this.state.dialogueItems.map(dialogueItem => (
              <DialogueItem key={dialogueItem.id} dialogueItem={dialogueItem} />
            ))}
        </DialogueItems>
        );
    }
}


document.addEventListener('DOMContentLoaded', () => {
    ReactDOM.render(
      <DialogueBox />,
      document.getElementById('results_box'),
    )
})