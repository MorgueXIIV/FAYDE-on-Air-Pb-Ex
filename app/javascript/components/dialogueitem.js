import React from 'react'
import PropTypes from 'prop-types'

class DialogueItem extends React.Component {
    constructor(props) {
        super(props)
    }
    render() {
        const { dialogueItem } = this.props
        return <li>{dialogueItem.title}</li>
    }
}

export default DialogueItem

DialogueItem.propTypes = {
    DialogueItem: PropTypes.object.isRequired,
  }