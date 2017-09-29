var React = require('react');
var UserList = React.createClass({
  render: function() {
    var userRows = this.props.users.map(function(user) {
      return (
        <UserListRow key={user.id} user={user} />
      );
    });

    return (
      <table className="table table-hover user-list">
        <thead>
          <tr>
            <th>Name</th>
            <th>NetID</th>
            <th></th>
          </tr>
        </thead>
        <tbody>
          {userRows}
        </tbody>
      </table>
    );
  }
});
module.exports = UserList;
