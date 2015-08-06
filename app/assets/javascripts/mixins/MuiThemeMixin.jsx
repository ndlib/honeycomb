"use strict"
var mui = require("material-ui");
var ThemeManager = new mui.Styles.ThemeManager();
var HoneycombTheme = require("../themes/HoneycombTheme");
ThemeManager.setTheme(HoneycombTheme);

var MuiThemeMixin = {
  childContextTypes: {
    muiTheme: React.PropTypes.object
  },

  muiTheme: ThemeManager.getCurrentTheme(),

  getChildContext() {
    return {
      muiTheme: ThemeManager.getCurrentTheme()
    };
  },
};
module.exports = MuiThemeMixin;
