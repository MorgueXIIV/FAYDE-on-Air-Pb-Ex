// app/javascript/packs/components/TodoItems.jsx
import React from 'react'

class DialogueItems extends React.Component {
  constructor(props) {
    super(props)
  }
  render() {
    return (
      <ul>{this.props.children}</ul>
    )
  }
}
export default DialogueItems