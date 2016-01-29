//app/assets/javascripts/components.js
//= require_self
//= require react_ujs
React = require("react");
ReactDOM = require("react-dom");

// mixins
APIResponseMixin = require("./mixins/APIResponseMixin");
DialogMixin = require("./mixins/DialogMixin");
DraggableMixin = require("./mixins/DraggableMixin");
HoneypotImageMixin = require("./mixins/HoneypotImageMixin");
HorizontalScrollMixin = require("./mixins/HorizontalScrollMixin");
MuiThemeMixin = require("./mixins/MuiThemeMixin");
TitleConcatMixin = require("./mixins/TitleConcatMixin");
GooglePickerMixin = require("./mixins/GooglePickerMixin");
GoogleCreatorMixin = require("./mixins/GoogleCreatorMixin");

// Page
FlashMessage = require("./components/FlashMessage");
EventEmitter = require("./EventEmitter");

// themes
HoneycombTheme = require("./themes/HoneycombTheme");

// uncategorized
CollectionPreviewModeToggle = require("./components/CollectionPreviewModeToggle");
CollectionPreviewPublishLink = require("./components/CollectionPreviewPublishLink");
DragContent = require("./components/DragContent");
HoneypotImage = require("./components/HoneypotImage");
ImageCaptionEditor = require("./components/ImageCaptionEditor");
ItemImageZoomButton = require("./components/ItemImageZoomButton");
ItemShowImageBox = require("./components/ItemShowImageBox");
LoadingImage = require("./components/LoadingImage");
Modal = require("./components/Modal");
OpenSeadragonViewer = require("./components/OpenSeadragonViewer");
ReactDropzone = require("./components/ReactDropzone");
ShowcasesPanel = require("./components/ShowcasesPanel");
PagesPanel = require("./components/PagesPanel");
Thumbnail = require("./components/Thumbnail");
GoogleImportButton = require("./components/GoogleImportButton");
GoogleExportButton = require("./components/GoogleExportButton");

// embed
EmbedCode = require("./components/embed/EmbedCode");

// forms
StylableDropTarget = require("./components/forms/StylableDropTarget");
FieldHelp = require("./components/forms/FieldHelp");
Form = require("./components/forms/Form");
FormMessageCenter = require("./components/forms/FormMessageCenter");
FormRow = require("./components/forms/FormRow");
FormSavedMsg = require("./components/forms/FormSavedMsg");
FormServerErrorMsg = require("./components/forms/FormServerErrorMsg");
ItemMetaDataForm = require("./components/forms/ItemMetaDataForm");
ExternalCollectionForm = require("./components/forms/ExternalCollectionForm");
StringField = require("./components/forms/StringField");
SubmitButton = require("./components/forms/SubmitButton");
TextField = require("./components/forms/TextField");
DateField = require("./components/forms/DateField");
HtmlField = require("./components/forms/HtmlField");
UploadFileField = require("./components/forms/UploadFileField");
MultipleField = require("./components/forms/MultipleField");
MultipleFieldDisplayValue = require("./components/forms/MultipleFieldDisplayValue");
DropzoneForm = require("./components/forms/DropzoneForm");
ButtonLink = require("./components/forms/ButtonLink");
SiteObjectCard = require("./components/forms/SiteObjectCard");
SitePath = require("./components/forms/SitePath");
MetaDataConfigurationForm = require("./components/forms/MetaDataConfigurationForm");

// panel
Panel = require("./components/panel/Panel");
PanelBody = require("./components/panel/PanelBody");
PanelFooter = require("./components/panel/PanelFooter");
PanelHeading = require("./components/panel/PanelHeading");

// people search
PeopleSearch = require("./components/people_search/PeopleSearch");
PeopleSearchForm = require("./components/people_search/PeopleSearchForm");
PeopleSearchFormButton = require("./components/people_search/PeopleSearchFormButton");
PeopleSearchList = require("./components/people_search/PeopleSearchList");
PeopleSearchListItem = require("./components/people_search/PeopleSearchListItem");

// publish
CollectionPublishToggle = require("./components/publish/CollectionPublishToggle");
ItemPublishEmbedPanel = require("./components/publish/ItemPublishEmbedPanel");
PublishToggle = require("./components/publish/PublishToggle");
ShowcasePublishAction = require("./components/publish/ShowcasePublishAction");

// showcase editor
AddItemsBar = require("./components/showcase_editor/AddItemsBar");
EditLink = require("./components/showcase_editor/EditLink");
Item = require("./components/showcase_editor/Item");
ItemList = require("./components/showcase_editor/ItemList");
NewSectionDropzone = require("./components/showcase_editor/NewSectionDropzone");
Section = require("./components/showcase_editor/Section");
SectionDescription = require("./components/showcase_editor/SectionDescription");
SectionDragContent = require("./components/showcase_editor/SectionDragContent");
SectionImage = require("./components/showcase_editor/SectionImage");
SectionList = require("./components/showcase_editor/SectionList");
ShowcaseEditor = require("./components/showcase_editor/ShowcaseEditor");
ShowcaseEditorTitle = require("./components/showcase_editor/ShowcaseEditorTitle");

// user panel
UserList = require("./components/user_panel/UserList");
UserListRow = require("./components/user_panel/UserListRow");
UserPanel = require("./components/user_panel/UserPanel");

// store initiliazers
CollectionStoreInitializer = require("./components/store_initializers/collection");
MetaDataConfigurationStore = require('./stores/MetaDataConfigurationStore');
