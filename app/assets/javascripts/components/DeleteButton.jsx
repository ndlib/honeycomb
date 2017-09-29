'use strict'
var React = require('react');
var mui = require("material-ui");

var ItemStore = require("../stores/ItemStore");
var ItemActions = require('../actions/ItemActions');

var DeleteButton = React.createClass({
  propTypes: {
    type: React.PropTypes.oneOf(['item', 'showcase', 'page']).isRequired,
    id: React.PropTypes.string.isRequired,
    callback: React.PropTypes.func,
  },

  getInitialState: function() {
    return {
      deleting: false,
      open: false,
      failOpen: false,
    }
  },

  dismissConfirm: function() {
    ItemStore.removeListener("ItemDeleteFinished", this.deleteSuccess);
    ItemActions.removeListener("ItemDeleteFailed", this.deleteFailed);
    this.setState({
      deleting: false,
      open: false,
    });
  },

  deleteFailed: function() {
    this.dismissConfirm();
    this.setState({
      open: false,
      failOpen: true,
    })
  },

  deleteSuccess: function() {
    this.dismissConfirm();
    if(this.props.callback) {
      this.props.callback(this.props.id);
    }
  },

  genericDelete: function(url) {
    $.ajax({
      url: url,
      dataType: "json",
      method: "DELETE",
      success: (function(data) {
        this.deleteSuccess();
      }).bind(this),
      error: (function(xhr) {
        this.deleteFailed();
      }).bind(this),
    });
  },

  delete: function() {
    this.setState({
      deleting: true,
    });

    var id = this.props.id;
    switch(this.props.type) {
      case 'item':
        ItemStore.on("ItemDeleteFinished", this.deleteSuccess);
        ItemActions.on("ItemDeleteFailed", this.deleteFailed);
        ItemActions.delete(id);
      break;
      case 'showcase':
        var url = '/v1/showcases/' + id;
        this.genericDelete(url);
      break;
      case 'page':
        var url = '/v1/pages/' + id;
        this.genericDelete(url);
      break;
    }
  },

  confirmDelete: function() {
    this.setState({ open: true })
  },

  dismissMessage: function() {
    this.setState({
      open: false,
      failOpen: false
    })
  },

  confirmMessage: function() {
    this.delete();
  },

  confirmActions: function() {
    if(this.state.deleting) {
      return ([<mui.CircularProgress key="progress" mode="indeterminate" size={0.5} />]);
    } else {
      return([this.cancelDismiss(), this.dialogConfirm()]);
    }
  },

  cancelDismiss: function() {
    return (
        <mui.FlatButton
        key={'cancel'}
        label="Cancel"
        primary={true}
        onTouchTap={this.dismissMessage}
      />
    );
  },

  okDismiss: function() {
    return (
      <mui.FlatButton
        key={'dismiss'}
        label="OK"
        primary={true}
        onTouchTap={this.dismissMessage}
      />
    );
  },

  dialogConfirm: function() {
    return (
      <mui.FlatButton
        key={'confirm'}
        label="Yes"
        primary={true}
        onTouchTap={this.confirmMessage}
      />
    );
  },

  render: function() {
    return (
      <div>
        <mui.IconButton onClick={this.confirmDelete} >
          <mui.FontIcon className="material-icons" color="#f44336">delete</mui.FontIcon>
        </mui.IconButton>
        <mui.Dialog
          ref="deleteConfirm"
          title="Delete"
          defaultOpen={false}
          open={this.state.open}
          actions={this.confirmActions()}
        >
          <p>Are you sure you want to delete this entry?</p>
        </mui.Dialog>
        <mui.Dialog
          ref="failedConfirm"
          title="Delete Failed"
          defaultOpen={false}
          open={this.state.failOpen}
          actions={[this.okDismiss()]}
        >
          <p>Delete failed, check entry detail view for more information.</p>
        </mui.Dialog>
      </div>
    );
  }

});

module.exports = DeleteButton;
