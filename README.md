Phonetag
--------

Phonetag is a simple voice mailbox. Set up a Phonetag instance and you'll have
a phone number you can hand out that will never actually call your phone. It will
just email you when somebody has left a message.

### Setup
The recommended way to use Phonetag is to deploy an instance on Heroku.

1. Create a [Twilio][3] account. A trial account is enough for this.
1. Deploy to Heroku.
1. Add your email address to the sandbox of your [Mailgun account][4] (otherwise it won't send emails to that address).
1. [Create a phone number on Twilio][1]
1. For the voice section of the Twilio number, set the incoming webhook to POST to /call on your new Heroku instance. ![twilio configuration][2]
1. Call your new number and leave yourself a message!


[1]: https://www.twilio.com/console/phone-numbers/incoming
[2]: https://dl.dropbox.com/s/ezoym1ltutn6sar/Screenshot%202016-09-09%2010.50.01.png
[3]: https://www.twilio.com/
[4]: https://mailgun.com/app/testing/recipients
