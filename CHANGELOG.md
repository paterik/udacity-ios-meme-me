# ChangeLog of MemeMe

All notable changes of MemeMe release series are documented in this file using the [Keep a CHANGELOG](http://keepachangelog.com/) principles.

_This MemeMe changelog documentation start with version 1.0.0 (2016-10-14)_

## [2.0.6], 2016-11-02:
_current_

### Added

* template for app icons

### Changes

* new app name/config
* new app iconSet/logo
* new app launchScreen
* new zero-state images

### Fixes

* minor cs/qc related issues

### Removed

* old sketch app template(s)


## [2.0.5], 2016-10-27:

### Added

* new icon for updated memes
* new icon for sample memes
* affinity designer template for app icons
* sample meme import dialog on start up

### Changes

* switch from textField to textView elements as meme text input controls
* multiline support and memeText effect improvements
* minor code refactoring and stability improvements
* enforce porttrait orientation on detailView and editView
* improve new meme icon
* generalize template naming (sketch/ad)

### Removed

* obsolete presentation mode in editView
* obsolete internal functions
* debug output lines

### Fixes

* image quality/positioning issue based on bad constraints
* uppercase bug during input on iPhone 6 devices


## [2.0.4], 2016-10-25:

### Changes

* version as label string now
* minor refactoring
* minor review related changes/improvements
* minor codestyle changes


## [2.0.3], 2016-10-23:

### Changes

* minor code quality improvements
* model change for created field, using const now

### Fixed

* fix review related issues
* fix detailView image positioning problem
* auto uppercase bug on physically devices


## [2.0.2], 2016-10-23:

### Added

* detailView scene instead using editView presentation mode

### Changes

* minor code quality improvements
* date issue in changelog
* updated memes will be flagged as new meme now


## [2.0.1], 2016-10-22:

### Added

* presentation view mode for existing memes

### Changes

* detailView for meme is available now by touching the corresponding row/cell
* input fields for top and bottom meme-text are now capitalized

### Fixed

* minor review releated issues


## [2.0.0], 2016-10-22:

### Added

* list of current memes in table and collectionView
* edit existing meme swipe function
* delete exisiting meme swipe function
* pod file definition

### Changes

* improve image export/share quality
* minor code quality improvments

### Fixed

* export image rendiring bug


## [1.0.3], 2016-10-16:

### Changes

* improve user dialog typo
* minor code refactoring
* update media assets


## [1.0.2], 2016-10-15:

### Fixed

* font resource problem

### Changes

* add alternative font in available font range definition


## [1.0.1], 2016-10-15:

### Fixed

* font initialization issue
* bug in oriantation switch during input
* project group structure

### Changes

* update action icon
* refatoring, prevent code replication
* change image scale method
* minor review related issues

### Removed

* UIOutlinedTextField class definition

### Added

* font availability checker
* font alternatives as failback for missing device fonts
* UIMemeTextField class definition

## [1.0.0], 2016-10-14:

### Added

* main code base (initial commit)
* minor documentation
* changelog and license
