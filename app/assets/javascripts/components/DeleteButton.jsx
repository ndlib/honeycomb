'use strict'
var React = require('react');
var mui = require("material-ui");

var ItemStore = require("../stores/ItemStore");
var ItemActions = require('../actions/ItemActions');

var DeleteButton = React.createClass({
  mixins: [DialogMixin],

  propTypes: {
    type: React.PropTypes.oneOf(['item', 'showcase', 'page']).isRequired,
    id: React.PropTypes.string.isRequired,
    callback: React.PropTypes.func,
  },

  getInitialState: function() {
    return {
      deleting: false,
    }
  },

  dismissConfirm: function() {
    ItemStore.removeListener("ItemDeleteFinished", this.itemDeleteFinished);
    ItemActions.removeListener("ItemDeleteFailed", this.itemDeleteFailed);
    this.refs.deleteConfirm.dismiss();
  },

  itemDeleteFailed: function() {
    this.dismissConfirm();
    this.refs.failedConfirm.show();
  },

  itemDeleteFinished: function() {
    this.dismissConfirm();
    if(this.props.callback) {
      this.props.callback(this.props.id);
    }
  },

  delete: function() {
    this.setState({
      deleting: true,
    });

    let id = this.props.id;
    switch(this.props.type) {
      case 'item':
        ItemStore.on("ItemDeleteFinished", this.itemDeleteFinished);
        ItemActions.on("ItemDeleteFailed", this.itemDeleteFailed);
        ItemActions.delete(id);
      break;
      case 'showcase':
        console.log("cant delete showcases yet");
        // return '/showcases/' + id;
      break;
      case 'page':
        console.log("cant delete pages yet");
        // return '/pages/' + id;
      break;
    }
  },

  confirmDelete: function() {
    this.refs.deleteConfirm.show();
  },

  dismissMessage: function() {
    this.refs.deleteConfirm.dismiss();
    this.refs.failedConfirm.dismiss();
  },

  confirmMessage: function() {
    this.delete();
  },

  confirmActions: function() {
    if(this.state.deleting) {
      return ([<mui.CircularProgress mode="indeterminate" size={0.5} />]);
    } else {
      return([this.cancelDismiss(), this.dialogConfirm()]);
    }
  },

  render: function() {
    return (
      <div>
        <mui.IconButton onClick={this.confirmDelete} >
          <mui.FontIcon className="material-icons" color="#f44336">delete</mui.FontIcon>
        </mui.IconButton>
        <mui.Dialog
          ref="deleteConfirm"
          modal={true}
          title="Delete"
          defaultOpen={false}
          actions={this.confirmActions()}
        >
          <p>Are you sure you want to delete?</p>
        </mui.Dialog>
        <mui.Dialog
          ref="failedConfirm"
          modal={true}
          title="Delete Failed"
          defaultOpen={false}
          actions={[this.okDismiss()]}
        >
          <p>Delete failed, check object details for reasons.</p>
        </mui.Dialog>
      </div>
    );
  }

});

module.exports = DeleteButton;
