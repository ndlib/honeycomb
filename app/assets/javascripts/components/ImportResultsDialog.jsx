var React = require('react');
var mui = require("material-ui");
var Dialog = mui.Dialog;
var RaisedButton = mui.RaisedButton;
var FlatButton = mui.FlatButton;

var ImportResultsDialog = React.createClass({
  mixins: [MuiThemeMixin],

  propTypes: {
    open: React.PropTypes.bool.isRequired,
    results: React.PropTypes.object.isRequired,
  },

  getInitialState: function() {
    return {
      open: this.props.open,
    };
  },

  componentWillReceiveProps: function(nextProps) {
    this.setState({
      open: nextProps.open,
    });
  },

  componentDidMount: function() {
    if(this.state.open){
      this.refs.ResultsDialog.show();
    } else {
      this.refs.ResultsDialog.dismiss();
    }
  },

  componentDidUpdate: function(prevProps, prevState) {
    if(this.state.open){
      this.refs.ResultsDialog.show();
    } else {
      this.refs.ResultsDialog.dismiss();
    }
  },

  handleClose: function() {
    this.setState({ open: false });
  },

  summary: function() {
    var summary = this.props.results.summary;
    var totals = (<div>Of { summary.total_count } total rows:</div>);

    var newCount = null;
    if (summary.new_count > 0) {
      newCount = (<div>{ summary.new_count } items were created.</div>);
    }
    var changedCount = null;
    if (summary.changed_count > 0) {
      changedCount = (<div>{ summary.changed_count } items were updated.</div>);
    }
    var unchangedCount = null;
    if (summary.unchanged_count > 0) {
      unchangedCount = (<div>{ summary.unchanged_count } items had no changes.</div>);
    }

    return [totals, newCount, changedCount, unchangedCount];
  },

  errors: function() {

    var summary = this.props.results.summary;
    if (summary.error_count > 0) {
      var errors = this.props.results.errors;
      var tableRows = [];

      for(rowIndex in errors){
        var row = errors[rowIndex];
        var errorDetails = [];
        row.errors.forEach(function(error) {
          errorDetails.push(<div>{ error }</div>);
        });

        tableRows.push((
          <tr>
            <td>{ parseInt(rowIndex) + 2 }</td>
            <td>{ row.item.user_defined_id }</td>
            <td>{ row.item.metadata.name ? row.item.metadata.name[0] : '' }</td>
            <td>
              { errorDetails }
            </td>
          </tr>
        ));
      };

      return [
        <div>{ summary.error_count } rows were not imported due to the following errors:</div>,
        <table className="table table-striped">
          <thead>
            <tr>
              <th>Row</th>
              <th>Item Id</th>
              <th>Item Name</th>
              <th>Errors</th>
            </tr>
          </thead>
          <tbody>
            { tableRows }
          </tbody>
        </table>
      ];
    }
    return null;
  },

  render: function() {
    const actions = [
      <FlatButton
        label="OK"
        primary={true}
        onTouchTap={this.handleClose}
      />,
    ];
    var dialogBody = null;
    if(this.state.open){
      dialogBody = (
        <div>
          { this.summary() }
          { this.errors() }
        </div>
      );
    }

    return (
      <div>
        <Dialog
          ref={ "ResultsDialog" }
          title="Import Results"
          actions={actions}
          modal={false}
          open={this.state.open}
          onRequestClose={this.handleClose}
          bodyStyle={ { overflowY: "auto", maxHeight: "70vh" } }
        >
          { dialogBody }
        </Dialog>
      </div>
    );
  }
});
module.exports = ImportResultsDialog;
