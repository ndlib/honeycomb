# Change Log

## [3.1.0](https://github.com/ndlib/honeycomb/tree/v3.1.0) (2016-05-03)
[Full Changelog](https://github.com/ndlib/honeycomb/compare/v3.0.0...v3.1.0)

###New features/enhancements:###
  - Admins can now import images from external url ([DEC-931](https://jira.library.nd.edu/browse/DEC-931), [#354](https://github.com/ndlib/honeycomb/pull/354))
  - Collection list now renders 15x faster ([DEC-648](https://jira.library.nd.edu/browse/DEC-648), [#363](https://github.com/ndlib/honeycomb/pull/363))
  - Improved tracking of changes to collection data ([#357](https://github.com/ndlib/honeycomb/pull/357))
  - Searches now use OR by default, simplifying the way that item searches are performed ([DEC-913](https://jira.library.nd.edu/browse/DEC-913), [#351](https://github.com/ndlib/honeycomb/pull/351))

###Bug fixes:###
  - Fixed a bug preventing users from editing items in Internet Explorer ([DEC-925](https://jira.library.nd.edu/browse/DEC-925), [#355](https://github.com/ndlib/honeycomb/pull/355))
  - Fixed a bug that prevented users from hiding metadata fields from items ([DEC-927](https://jira.library.nd.edu/browse/DEC-927), [#364](https://github.com/ndlib/honeycomb/pull/364))
  - New items were not showing the correct image in search ([DEC-950](https://jira.library.nd.edu/browse/DEC-950), [#361](https://github.com/ndlib/honeycomb/pull/361))
  - Fixed a bug that forced the user to double click the new meta field button in Safari ([DEC-928](https://jira.library.nd.edu/browse/DEC-928), [#359](https://github.com/ndlib/honeycomb/pull/359))
  - Fixed a bug that prevented rendering external collections ([DEC-934](https://jira.library.nd.edu/browse/DEC-934), [#356](https://github.com/ndlib/honeycomb/pull/356))
  - Fixed a bug that prevented users from Publishing/Previewing collections and several other tasks in Safari ([DEC-924](https://jira.library.nd.edu/browse/DEC-924), [#353](https://github.com/ndlib/honeycomb/pull/353))

## [3.0.0](https://github.com/ndlib/honeycomb/tree/v3.0.0) (2016-03-30)
[Full Changelog](https://github.com/ndlib/honeycomb/compare/v2.0.0...v3.0.0)

###New features/enhancements:###

**Now requires Postgres ([DEC-732](https://jira.library.nd.edu/browse/DEC-732))**
  - Migrate and test on preprod ([DEC-714](https://jira.library.nd.edu/browse/DEC-714), [#327](https://github.com/ndlib/honeycomb/pull/327))
  - Update Developer Machines to postgres. ([DEC-733](https://jira.library.nd.edu/browse/DEC-733), [#302](https://github.com/ndlib/honeycomb/pull/302))
  - Create database migration ([DEC-738](https://jira.library.nd.edu/browse/DEC-738), [#306](https://github.com/ndlib/honeycomb/pull/306))

**Users can now customize what metadata appears on items within a collection ([DEC-477](https://jira.library.nd.edu/browse/DEC-477))**
  - As an admin I want to be able to upload full text items. ([DEC-731](https://jira.library.nd.edu/browse/DEC-731), [#305](https://github.com/ndlib/honeycomb/pull/305))
  - Migrate collection_configuration to the collection table. ([DEC-763](https://jira.library.nd.edu/browse/DEC-763), [#318](https://github.com/ndlib/honeycomb/pull/318))
  - Fix Export/Import ([DEC-801](https://jira.library.nd.edu/browse/DEC-801), [#328](https://github.com/ndlib/honeycomb/pull/328))
  - Remove the public interface to metadata fields. ([DEC-755](https://jira.library.nd.edu/browse/DEC-755), [#326](https://github.com/ndlib/honeycomb/pull/326))
  - Create field should return the new field data ([DEC-802](https://jira.library.nd.edu/browse/DEC-802), [#325](https://github.com/ndlib/honeycomb/pull/325))
  - Add a way to remove metadata from the configuration ([DEC-796](https://jira.library.nd.edu/browse/DEC-796), [#324](https://github.com/ndlib/honeycomb/pull/324))
  - Build a node app. ([DEC-766](https://jira.library.nd.edu/browse/DEC-766), [#323](https://github.com/ndlib/honeycomb/pull/323))
  - Build a node app. ([DEC-766](https://jira.library.nd.edu/browse/DEC-766), [#321](https://github.com/ndlib/honeycomb/pull/321))
  - Create form to edit a metadata configuration field ([DEC-760](https://jira.library.nd.edu/browse/DEC-760), [#316](https://github.com/ndlib/honeycomb/pull/316))
  - Map the current config to the database. ([DEC-756](https://jira.library.nd.edu/browse/DEC-756), [#315](https://github.com/ndlib/honeycomb/pull/315))
  - Create view to show existing metadata configuration ([DEC-759](https://jira.library.nd.edu/browse/DEC-759), [#313](https://github.com/ndlib/honeycomb/pull/313))
  - Load the jsonb fields from the current yml file ([DEC-739](https://jira.library.nd.edu/browse/DEC-739), [#307](https://github.com/ndlib/honeycomb/pull/307))
  - Cannot save date metadata field ([DEC-837](https://jira.library.nd.edu/browse/DEC-837), [#340](https://github.com/ndlib/honeycomb/pull/340))
  - Cannot delete a collection ([DEC-815](https://jira.library.nd.edu/browse/DEC-815), [#342](https://github.com/ndlib/honeycomb/pull/342))
  - Creating new collection fails ([DEC-829](https://jira.library.nd.edu/browse/DEC-829), [#337](https://github.com/ndlib/honeycomb/pull/337))
  - Cannot create a new metadata field ([DEC-835](https://jira.library.nd.edu/browse/DEC-835), [#339](https://github.com/ndlib/honeycomb/pull/339))
  - Cannot restore a metadata field ([DEC-832](https://jira.library.nd.edu/browse/DEC-832), [#338](https://github.com/ndlib/honeycomb/pull/338))
  - Add metadata dropdown doesn't appear ([DEC-773](https://jira.library.nd.edu/browse/DEC-773), [#312](https://github.com/ndlib/honeycomb/pull/312))
  - Unable to save original language meta ([DEC-684](https://jira.library.nd.edu/browse/DEC-684), [#297](https://github.com/ndlib/honeycomb/pull/297))

**Users can now create Pages ([DEC-492](https://jira.library.nd.edu/browse/DEC-492))**
  - Change redactor to match beehive page ([DEC-787](https://jira.library.nd.edu/browse/DEC-787), [#322](https://github.com/ndlib/honeycomb/pull/322))
  - As a user of beehive, I need to view pages content for a collection ([DEC-662](https://jira.library.nd.edu/browse/DEC-662), [#320](https://github.com/ndlib/honeycomb/pull/320))
  - As a user I would like to be able to choose what pages/showcases appears on MY homepage. ([DEC-655](https://jira.library.nd.edu/browse/DEC-655), [#308](https://github.com/ndlib/honeycomb/pull/308))
  - Associate items with pages (data layer) ([DEC-682](https://jira.library.nd.edu/browse/DEC-682), [#299](https://github.com/ndlib/honeycomb/pull/299))
  - Allow images to be added to site pages ([DEC-650](https://jira.library.nd.edu/browse/DEC-650), [#294](https://github.com/ndlib/honeycomb/pull/294))
  - As an editor, I need to be able to add a representational image to a page so that it is viewable in beehive ([DEC-654](https://jira.library.nd.edu/browse/DEC-654), [#293](https://github.com/ndlib/honeycomb/pull/293))
  - Build API for beehive ([DEC-652](https://jira.library.nd.edu/browse/DEC-652), [#292](https://github.com/ndlib/honeycomb/pull/292))
  - Refactor ordering so that it can apply to both pages and showcases ([DEC-653](https://jira.library.nd.edu/browse/DEC-653), [#291](https://github.com/ndlib/honeycomb/pull/291))
  - Design and add models ([DEC-639](https://jira.library.nd.edu/browse/DEC-639), [#290](https://github.com/ndlib/honeycomb/pull/290))
  - Cannot upload image in the page redactor ([DEC-864](https://jira.library.nd.edu/browse/DEC-864), [#345](https://github.com/ndlib/honeycomb/pull/345))
  - Try to add showcase to site path ([DEC-849](https://jira.library.nd.edu/browse/DEC-849), [#344](https://github.com/ndlib/honeycomb/pull/344))
  - Cannot insert items into page if collection is not published or preview enabled ([DEC-695](https://jira.library.nd.edu/browse/DEC-695), [#303](https://github.com/ndlib/honeycomb/pull/303))
  - Pages edit does not load if collection.site_objects is nil ([DEC-696](https://jira.library.nd.edu/browse/DEC-696), [#304](https://github.com/ndlib/honeycomb/pull/304))

**Removed Exhibits model ([DEC-376](https://jira.library.nd.edu/browse/DEC-376))**
  - Merge collection model with exhibit model ([DEC-376](https://jira.library.nd.edu/browse/DEC-376), [#285](https://github.com/ndlib/honeycomb/pull/285))
  - Merge collection model with exhibit model ([DEC-376](https://jira.library.nd.edu/browse/DEC-376), [#289](https://github.com/ndlib/honeycomb/pull/289))
  - Once done, remove Exhibition and Exhibit ([DEC-627](https://jira.library.nd.edu/browse/DEC-627), [#284](https://github.com/ndlib/honeycomb/pull/284))
  - Fix views ([DEC-626](https://jira.library.nd.edu/browse/DEC-626), [#283](https://github.com/ndlib/honeycomb/pull/283))
  - Migrate any Exhibit model methods to Collections ([DEC-635](https://jira.library.nd.edu/browse/DEC-635), [#282](https://github.com/ndlib/honeycomb/pull/282))
  - Migrate Exhibit->Showcase relationship to Collection->Showcase ([DEC-636](https://jira.library.nd.edu/browse/DEC-636), [#280](https://github.com/ndlib/honeycomb/pull/280))
  - Merge image fields into collection ([DEC-633](https://jira.library.nd.edu/browse/DEC-633), [#277](https://github.com/ndlib/honeycomb/pull/277))
  - Merge enable_search into collection ([DEC-631](https://jira.library.nd.edu/browse/DEC-631), [#278](https://github.com/ndlib/honeycomb/pull/278))
  - Merge hide_title_on_home_page into collection ([DEC-632](https://jira.library.nd.edu/browse/DEC-632), [#279](https://github.com/ndlib/honeycomb/pull/279))
  - Migrate about text to collections ([DEC-625](https://jira.library.nd.edu/browse/DEC-625), [#275](https://github.com/ndlib/honeycomb/pull/275))
  - Merge copyright field into collection ([DEC-629](https://jira.library.nd.edu/browse/DEC-629), [#276](https://github.com/ndlib/honeycomb/pull/276))
  - Merge enable_browse into collection ([DEC-630](https://jira.library.nd.edu/browse/DEC-630), [#274](https://github.com/ndlib/honeycomb/pull/274))
  - Merge handling of description fields ([DEC-617](https://jira.library.nd.edu/browse/DEC-617), [#273](https://github.com/ndlib/honeycomb/pull/273))
  - Merge exhibit name into collection name_line_1, name_line_2 ([DEC-615](https://jira.library.nd.edu/browse/DEC-615), [#268](https://github.com/ndlib/honeycomb/pull/268))
  - Merge URL field into collection model ([DEC-616](https://jira.library.nd.edu/browse/DEC-616), [#267](https://github.com/ndlib/honeycomb/pull/267))
  
###Bug fixes:###
- Images are broken in a few places ([DEC-839](https://jira.library.nd.edu/browse/DEC-839), [#341](https://github.com/ndlib/honeycomb/pull/341))
- Search and Browse Stretched Images ([DEC-774](https://jira.library.nd.edu/browse/DEC-774), [#314](https://github.com/ndlib/honeycomb/pull/314))

## [2.0.0](https://github.com/ndlib/honeycomb/tree/v2.0.0)

###New features/enhancements:###

###Bug fixes:###

## [1.0.0](https://github.com/ndlib/honeycomb/tree/v1.0.0)

###New features/enhancements:###

###Bug fixes:###
