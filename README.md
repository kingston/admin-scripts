Administration Script Quickies
==============================

Just a couple scripts I wrote that came in handy here and there.  No
guarantees of anything, but they have been pretty handy for just getting
things up and running.

**NOTE: This is a work in progress so there might not be much here initially**

Any feedback/suggestions are welcome (web _at_ kingstontam.com)

Backup Scripts
--------------
Directory: backup/

### backup.sh
Backs up a directory and SQL database on a weekly and daily basis (configurable)

It will rotate backups so backups beyond a certain week/day will be deleted automatically

Tested on GNU Bash version 3.2.25

Search Scripts
--------------
Directory: search/

### search.sh
Performs a case-sensitive search in the current directory.  It basically is a wrapper for grep, but just makes it a little easier to do the search (with coloring and ignoring git directories).

Makes life easier to use a bash alias, e.g. "alias s='~/[PATH_TO_SCRIPT]/search.sh"

### searchi.sh
Performs a case-insensitive search in the current directory.  Similar in function to search.sh.

