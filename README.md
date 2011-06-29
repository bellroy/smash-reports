= Smash Reports

A simple SQL reporting system.

Point Smash Reports at a SQL database, and create simple reports from SQL
SELECT statements.

== Usage

There are rake tasks for simple user management:

    $ rake -T | grep users
    rake users:create  # Create a new user
    rake users:delete  # Delete a user
    rake users:list    # List users

All front-end functionality requires a logged-in user.

== History

* Originally developed at [Fallshaw](http://fallshaw.com.au/) for internal use,
released with their kind permission
* Spruced up and released by [TrikeApps](http://trikeapps.com/).
