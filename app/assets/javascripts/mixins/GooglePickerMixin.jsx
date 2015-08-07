// Requires the following within the page that uses this mixin:
//  <script type="text/javascript" src="https://apis.google.com/js/api.js"></script>
//

var GooglePickerMixin = {
  propTypes: {
    developerKey: React.PropTypes.string.isRequired,
    clientId: React.PropTypes.string.isRequired,
    appId: React.PropTypes.string.isRequired,
    authUri: React.PropTypes.string.isRequired,
  },

  getInitialState: function() {
    return {
      pickerApiLoaded: false,
      oauthToken: null
    };
  },

  loadPicker: function() {
    gapi.load("auth", {"callback": this.onAuthApiLoad});
    gapi.load("picker", {"callback": this.onPickerApiLoad});
  },

  onAuthApiInit: function(clientId) {
    window.gapi.auth.authorize(
      {
        "client_id": this.props.clientId,
        "scope": "https://www.googleapis.com/auth/drive.file",
        "hd": "nd.edu"
      },
      this.handleAuthResult);
  },

  onAuthApiLoad: function() {
    gapi.auth.init(this.onAuthApiInit);
  },

  onPickerApiLoad: function() {
    this.setState({
      pickerApiLoaded: true
    });
    this.createPicker();
  },

  handleAuthResult: function(authResult) {
    if (authResult && !authResult.error) {
      this.setState({ oauthToken: authResult.access_token });
      this.createPicker();
    }
  },

  createPicker: function() {
    if (this.state.pickerApiLoaded && this.state.oauthToken) {
      var view = new google.picker.DocsView(google.picker.ViewId.SPREADSHEETS);
      view.setMimeTypes("application/vnd.google-apps.spreadsheet");
      view.setMode(google.picker.DocsViewMode.LIST);
      var picker = new google.picker.PickerBuilder()
          .setAppId(this.props.appId)
          .setOAuthToken(this.state.oauthToken)
          .addView(view)
          .setDeveloperKey(this.props.developerKey)
          .setCallback(this.pickerCallback)
          .build();
       picker.setVisible(true);
    }
  },

  pickerCallback: function(data) {
    if (data.action == google.picker.Action.PICKED) {
      var fileId = data.docs[0].url;

      $.ajax({
        url: this.props.authUri,
        dataType: "json",
        data: {
          file_name: fileId,
          sheet_name: ""
        },
        method: "POST",
        success: (function(data, textStatus) {
          window.location.href = data.auth_uri;
        }),
        error: (function(xhr) {
          alert(xhr);
        })
      });
    }
  },
};

module.exports = GooglePickerMixin;
