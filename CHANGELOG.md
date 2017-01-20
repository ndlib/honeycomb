# Change Log

## [3.7.0](https://github.com/ndlib/honeycomb/tree/v3.7.0) (2017-01-20)
[Full Changelog](https://github.com/ndlib/honeycomb/compare/v3.6.0...v3.7.0)

**New features/enhancements:**
- Import now allows creation of a parent/child relationship by including a "Parent Identifier" field. ([DEC-1243](https://jira.library.nd.edu/browse/DEC-1243), [#483](https://github.com/ndlib/honeycomb/pull/483))
- Export now exports the "Parent Identifier" of a child item's parent when it has one ([DEC-1244](https://jira.library.nd.edu/browse/DEC-1244), [#481](https://github.com/ndlib/honeycomb/pull/481))
- Changed item validation to only allow an item to have a single parent, no grandparents ([DEC-1261](https://jira.library.nd.edu/browse/DEC-1261), [#486](https://github.com/ndlib/honeycomb/pull/486))
- Changed search to allow querying children, grouped by parent ([DEC-1342](https://jira.library.nd.edu/browse/DEC-1342), [#488](https://github.com/ndlib/honeycomb/pull/488))


## [3.6.0](https://github.com/ndlib/honeycomb/tree/v3.6.0) (2016-12-14)
[Full Changelog](https://github.com/ndlib/honeycomb/compare/v3.5.0...v3.6.0)


###New features/enhancements:###
- Updated to SOLR 6.3.0 to support upcoming parent/child relationships ([DEC-1323](https://jira.library.nd.edu/browse/DEC-1323), [#477](https://github.com/ndlib/honeycomb/pull/477))

## [3.5.0](https://github.com/ndlib/honeycomb/tree/v3.5.0) (2016-11-30)
[Full Changelog](https://github.com/ndlib/honeycomb/compare/v3.4.0...v3.5.0)

###New features/enhancements:###
  - Most Recently created collections are now listed at the top of the collection page. [DEC-1302](https://jira.library.nd.edu/browse/DEC-1302)
  - Items, Pages, and Showcases now have a quick-delete button on their listing pages. [DEC-450](https://jira.library.nd.edu/browse/DEC-450)
  - Importing items is now possible thorugh CSV files as well as google sheets. [DEC-535](https://jira.library.nd.edu/browse/DEC-535)
  - Icons accross the website are now visible in IE [DEC-977](https://jira.library.nd.edu/browse/DEC-977)
  - Media (Audio/Video) items are now creatable and their thumbnail is customizable ([DEC-1156](https://jira.library.nd.edu/browse/DEC-1156), [DEC-1151](https://jira.library.nd.edu/browse/DEC-1151), [DEC-1115](https://jira.library.nd.edu/browse/DEC-1115))
  - Images and Media are placable in Showcases and Pages [DEC-1109](https://jira.library.nd.edu/browse/DEC-1109)
  - Showcase editor handle large collections more easily by paginating the item list and allowing users to search for those items they'd like to add [DEC-1299](https://jira.library.nd.edu/browse/DEC-1299)

###Bug fixes:###
  - Fixed a bug where an images could be stuck "uploading" forever. [DEC-1127](https://jira.library.nd.edu/browse/DEC-1127)
  - When browsing a collection it was possible to get into a state where a selected search facet would dissapear from the list but remain selected. This is fixed and now selected facets are always visible. [DEC-1133](https://jira.library.nd.edu/browse/DEC-1133)

## [3.4.0](https://github.com/ndlib/honeycomb/tree/v3.4.0) (2016-07-15)
[Full Changelog](https://github.com/ndlib/honeycomb/compare/v3.3.2...v3.4.0)

###New features/enhancements:###
  - Publishing/unpublishing was moved into a "Publish Options" form in the settings menu. ([DEC-948](https://jira.library.nd.edu/browse/DEC-948), [#387](https://github.com/ndlib/honeycomb/pull/387))
  - Updated to the newer version of Redactor, giving users access to more formatting functions for html meta fields and pages. ([DEC-1076](https://jira.library.nd.edu/browse/DEC-1076), [#390](https://github.com/ndlib/honeycomb/pull/390))
  - Images are now treated as it's own entity, greatly simplifying the database and application. It also now reuses images that have already been uploaded. ([DEC-1079](https://jira.library.nd.edu/browse/DEC-1079), [#395](https://github.com/ndlib/honeycomb/pull/395),[#396](https://github.com/ndlib/honeycomb/pull/396))
  - Published/unpublished status no longer shows on the collection listing. In the future, it won't be a simple binary flag, so this no longer makes sense on this view. ([DEC-1126](https://jira.library.nd.edu/browse/DEC-1126), [#397](https://github.com/ndlib/honeycomb/pull/397))
  - Removed name_save and description_save from the database. These were archived fields as part of the migration of these fields to the metadata field and are no longer needed. ([DEC-1102](https://jira.library.nd.edu/browse/DEC-1102), [#399](https://github.com/ndlib/honeycomb/pull/399))
  - Removed the brand bar to optimize usage of screen real estate. ([DEC-1132](https://jira.library.nd.edu/browse/DEC-1132), [#401](https://github.com/ndlib/honeycomb/pull/401))
  - Users can now change the order of their metadata fields. ([DEC-411](https://jira.library.nd.edu/browse/DEC-411), [#403](https://github.com/ndlib/honeycomb/pull/403))
  - Made a few cosmetic changes to edit forms to make them more consistent. ([#407](https://github.com/ndlib/honeycomb/pull/407),[#410](https://github.com/ndlib/honeycomb/pull/410))
  - Users can now add sub and superscripts to HTML based meta fields and pages. ([DEC-1066](https://jira.library.nd.edu/browse/DEC-1066), [#413](https://github.com/ndlib/honeycomb/pull/413))
  - Users can now add captions to images within Pages. ([DEC-795](https://jira.library.nd.edu/browse/DEC-795), [#414](https://github.com/ndlib/honeycomb/pull/414))

###Bug fixes:###
  - Fixed a the message that appears when deleting a section in a showcase. ([DEC-541](https://jira.library.nd.edu/browse/DEC-541), [#384](https://github.com/ndlib/honeycomb/pull/384))
  - Fixed the embed code for items. ([DEC-1070](https://jira.library.nd.edu/browse/DEC-1070), [#385](https://github.com/ndlib/honeycomb/pull/385))
  - Fixed a bug with generating seed data. ([DEC-1085](https://jira.library.nd.edu/browse/DEC-1085), [#388](https://github.com/ndlib/honeycomb/pull/388))
  - Fixed a bug that prevented users from saving a collection's settings with no custom url ([DEC-1090](https://jira.library.nd.edu/browse/DEC-1090), [#391](https://github.com/ndlib/honeycomb/pull/391))
  - Fixed a bug that modified an existing metadata config field if the user tried to create a new one with the same name. ([DEC-841](https://jira.library.nd.edu/browse/DEC-841), [#393](https://github.com/ndlib/honeycomb/pull/393))
  - Users can no longer create another metadata field with the same label as another. This was causing column mapping issues when importing google sheets. ([DEC-1093](https://jira.library.nd.edu/browse/DEC-1093), [#394](https://github.com/ndlib/honeycomb/pull/394))
  - Site settings default page will now highlight the homepage link, so that the user knows where they are in the settings menu. ([DEC-693](https://jira.library.nd.edu/browse/DEC-693), [#398](https://github.com/ndlib/honeycomb/pull/398))
  - Fixed an issue with reordering sections on showcases ([DEC-1098](https://jira.library.nd.edu/browse/DEC-1098), [#404](https://github.com/ndlib/honeycomb/pull/404))
  - Fixed broken preview links ([DEC-1101](https://jira.library.nd.edu/browse/DEC-1101), [#405](https://github.com/ndlib/honeycomb/pull/405))
  - Added missing Apple touch icons ([DEC-865](https://jira.library.nd.edu/browse/DEC-865), [#406](https://github.com/ndlib/honeycomb/pull/406))
  - Users can now preview a collection that has a custom url ([DEC-1140](https://jira.library.nd.edu/browse/DEC-1140), [#409](https://github.com/ndlib/honeycomb/pull/409))

## [3.3.2](https://github.com/ndlib/honeycomb/tree/v3.3.2) (2016-06-27)
[Full Changelog](https://github.com/ndlib/honeycomb/compare/v3.3.1...v3.3.2)

###Bug fixes:###
  - Fixed a bug that prevented saving collection settings with no custom url ([DEC-1090](https://jira.library.nd.edu/browse/DEC-1090), [#392](https://github.com/ndlib/honeycomb/pull/392))

## [3.3.1](https://github.com/ndlib/honeycomb/tree/v3.3.1) (2016-06-20)
[Full Changelog](https://github.com/ndlib/honeycomb/compare/v3.3.0...v3.3.1)

###Bug fixes:###
  - Items were not reflecting changes to metadata on the search page ([#383](https://github.com/ndlib/honeycomb/pull/383))

## [3.3.0](https://github.com/ndlib/honeycomb/tree/v3.3.0) (2016-06-16)
[Full Changelog](https://github.com/ndlib/honeycomb/compare/v3.2.0...v3.3.0)

###New features/enhancements:###
  - Users can now create a custom url for their collections, ex: collections.library.nd.edu/my-collection
 ([DEC-1044](https://jira.library.nd.edu/browse/DEC-1044), [#370](https://github.com/ndlib/honeycomb/pull/370), [#371](https://github.com/ndlib/honeycomb/pull/371))
  - Now renders a default thumbnail for items that only have metadata and no associated image to better support different types of collections ([DEC-1050](https://jira.library.nd.edu/browse/DEC-1050), [#373](https://github.com/ndlib/honeycomb/pull/373))
  - Facets can now have independent limits set per facet ([DEC-1039](https://jira.library.nd.edu/browse/DEC-1039), [#374](https://github.com/ndlib/honeycomb/pull/374))
  - Sort options can now have independent directions (ascending/descending) set per sort ([DEC-1040](https://jira.library.nd.edu/browse/DEC-1040), [#375](https://github.com/ndlib/honeycomb/pull/375))
  - Added a search clear button to more easily reset the search when filtering items in a collection ([DEC-1062](https://jira.library.nd.edu/browse/DEC-1062), [#377](https://github.com/ndlib/honeycomb/pull/377))

###Bug fixes:###
  - Renamed the OK button on the item preview ([DEC-1065](https://jira.library.nd.edu/browse/DEC-1065), [#378](https://github.com/ndlib/honeycomb/pull/378))
  - Fixed a few issues related to metadata configuration and creating new items ([DEC-1064](https://jira.library.nd.edu/browse/DEC-1064), [#376](https://github.com/ndlib/honeycomb/pull/376))
  - Fixed a bug that prevented Safari users from being able to view/edit items ([DEC-624](https://jira.library.nd.edu/browse/DEC-624), [#379](https://github.com/ndlib/honeycomb/pull/379))


## [3.2.0](https://github.com/ndlib/honeycomb/tree/v3.2.0) (2016-06-06)
[Full Changelog](https://github.com/ndlib/honeycomb/compare/v3.1.1...v3.2.0)

###New features/enhancements:###
  - Item list for a collection now renders significantly faster ([DEC-624](https://jira.library.nd.edu/browse/DEC-624),[#369](https://github.com/ndlib/honeycomb/pull/369))

## [3.1.1](https://github.com/ndlib/honeycomb/tree/v3.1.1) (2016-05-13)
[Full Changelog](https://github.com/ndlib/honeycomb/compare/v3.1.0...v3.1.1)

###Bug fixes:###
  - Fixed a bug that caused exporting large collections to fail. Exporting is also now significantly faster. ([DEC-1008](https://jira.library.nd.edu/browse/DEC-1008), [#368](https://github.com/ndlib/honeycomb/pull/368))

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
