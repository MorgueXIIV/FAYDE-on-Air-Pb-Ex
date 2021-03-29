import React from 'react'


let tipTop = "You: I'm not taking 'style' tips from someone who dresses like a washed-up TipTop racer."

function textCheck(txt) {
    if (txt == 'tiptop') {
        return tipTop
    } else if (!txt) {
        return 'Search for something in the box above!'
    } else {
        return "What about TipTop though?"
    }
}

class App extends React.Component {
    constructor(props) {
      super(props);
      this.state = {value: ''};
      this.state = {submission: ''}
      this.handleChange = this.handleChange.bind(this);
      this.handleSubmit = this.handleSubmit.bind(this);
    }
  
    handleChange(event) {
        this.setState({value: event.target.value});
    }

    handleSubmit(event) {  
        this.setState({submission: this.state.value})
        event.preventDefault();
    }    
  
    render () {
        return (
            <div>
            <h1>FAYDE Playback Experiment</h1>
            <label>
                    Select a database file:
                    <input type='file' accept='.db' /><br />
            </label>
            <form onSubmit={this.handleSubmit}>
                <label>
                    Search dialogue text for:
                    <input type="text" value={this.state.value} onChange={this.handleChange} />
                </label>
                <button type='submit'>Search</button>
            </form>
            <textarea value={textCheck(this.state.submission)}></textarea>
            </div>
        );
    }
  }

export default App