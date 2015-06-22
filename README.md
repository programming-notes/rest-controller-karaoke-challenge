# REST Controller Challenge

### Learning Competencies

* Learn the REST convention by implementing controller methods for 2 resources
* Understand how HTTP verbs map to CRUD actions
* Get familiar with RSpec testing of a sinatra app

### Summary

This challenge will involve implementing sinatra controller actions
to handle the following resources:

* Contacts
* Addresses nested within contacts

RSpec test cases exist that will guide you through writing the
controllers. Views are *mostly* provided with one key piece you
need to add. You'll need to create two files in app/controllers

* `contacts.rb`
* `addresses.rb`

You'll also need to make sure that your views know how to 'fake'
the appropriate HTTP request method. This should be all you need to
do to get the RSpec tests passing.

### Quickstart

1.  `bundle install`
2.  `rake db:reset`
3.  `rake db:test:prepare`
4.  `rspec`
