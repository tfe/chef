[Chef](http://github.com/tfe/chef/)
========

This app was written in the summer of 2008 primarily by [Todd Eichel](http://toddeichel.com/).

The original purpose of the application was three-fold:

* Capture web store notification emails from CMU's credit card payment/processing system and parse out the order data
* Send the customer an order confirmation email
* Do something useful with the order data

So the project was started with the intent to build a system to do the above three things. Scope was intentionally limited to that level so that the app might stand a chance of actually being finished. Plenty of ideas were generated for future versions in the process.

An emphasis was placed on simplicity, limited scope, use of existing code and plugins where possible, DRY and RESTful design, and best-practices use of the Rails framework, with an eye towards future interoperability and extensibility.


Installation
------------

It's a Rails app, so you need that.

1. Set up your database and modify `config/database.yml` to match. Run `rake db:migrate` to set up the database.
2. Set proper settings in the rest of the config files under `/config`. Passwords and addresses and such.
3. The app expects certain folders to exist on the IMAP server you want it to check. See `/config/mail_fetcher.yml`.
4. That's it?  I don't know.  Try it and let me know if it works.


Usage
-----

All the app needs to do is monitor an email box. There is a rake task (`rake server:check_mail`) that you just need to run at a set interval (like 5 minutes). There's no concurrency safety, so be careful not to run it too often.


Data Flow
---------

This is how data flows into, through, and out of the application:

1. When an order is placed (or attempted, CC validation failures are sent also), CMU's order processing system sends a notification email to the address passed to it with the order data (see also: [this basecamp message](http://cmutv.grouphub.com/projects/2243749/msg/cat/22372554/14888159/comments)). For this to work, this must be set to the same mailbox that the app is checking (currently store@cmutv.org, configurable in `/config/mail_fetcher.yml`).
2. Running the above `check_mail` rake task causes the application to check the store@cmutv.org mailbox over IMAP using the credentials in `/config/mail_fetcher.yml`.
3. Emails found to be from the CMU order processing system (using the address listed in /config/config.yml) are fetched, stored in the database, and moved to the IMAP folder 'Chef - Fetched' (folder name set in `/config/mail_fetcher.yml`).
4. Emails not found to be from the order processing system are moved to the IMAP folder 'INBOX' (also configured in `/config/mail_fetcher.yml`), effectively leaving them where they are. This logic is implemented in `OrderMailer.receive`, which returns normally if the message should be fetched and throws an exception if it should be left in the inbox.
5. Before `Email` records are created (saved to the database for the first time), `parse_to_order` is called on them. This goes through the email and pulls out the billing/shipping data, and the line items and products in the order.
6. Before `Order`s are created (saved to the database for the first time), `deliver_confirmation` is called on them (this is implemented in `OrderMailer`). This delivers a confirmation email to the customer through Gmail's SMTP servers with store@cmutv.org's credentials (stored in in /config/config.yml). The subject, from address, reply-to, etc. are customizable in /config/config.yml.  I'm not sure this step actually is implemented in the code yet.


Todo
----

The app is basically complete and functional.  I know it was fetching, parsing, storing emails, and sending confirmations, but there are lots of little things that need to be done if this is to be a mature production app.  Also there are plenty of feature ideas to implement.  Check the [Basecamp project](http://cmutv.grouphub.com/projects/2243749/) for more details.


Version History
---------------

### 1.0

* fetch emails, store in database
* parse emails and create orders
* send confirmation email to customer (not implemented)
* post order information to basecamp or google docs (not implemented)


Contact
-------

Problems, comments, and pull requests all welcome. [Find me on GitHub.](http://github.com/tfe/)


----

Copyright (c) 2008-2009 [Todd Eichel](http://toddeichel.com/) for [cmuTV](http://cmutv.org/), released under the MIT license.

