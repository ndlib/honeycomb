var React = require('react');
var UserPanel = React.createClass({
  propTypes: {
    initialUsers: React.PropTypes.array.isRequired,
    createUrl: React.PropTypes.string.isRequired,
    searchUrl: React.PropTypes.string.isRequired,
    title: React.PropTypes.string
  },
  getDefaultProps: function() {
    return {
      title: 'Users',
    }
  },
  getInitialState: function() {
    return {
      users: this.props.initialUsers
    };
  },
  addUser: function(personId) {
    $.ajax({
        url: this.props.createUrl,
        dataType: "json",
        type: "POST",
        data: {
            user: {
                username: personId
            }
        },
        success: (function(data) {
          this.userAdded(data);
        }).bind(this),
        error: (function(xhr, status, err) {
            console.error(this.props.createUrl, status, err.toString());
        }).bind(this)
    });
  },
  userExists: function(userId) {
    return _.some(this.state.users, function(user) {
      return user.id == userId;
    });
  },
  userAdded: function(user) {
    if (!this.userExists(user.id)) {
      var newUsers = this.state.users.concat([user]);
      this.setState({
        users: newUsers
      });
    }
  },
  render: function() {
    return (
      <div>
        <UserList users={this.state.users} />
        <PeopleSearch
          createUrl={this.props.createUrl}
          searchUrl={this.props.searchUrl}
          selectPerson={this.addUser} />
      </div>
    );
  }
});
module.exports = UserPanel;
