![375px-duplicateboy](https://cloud.githubusercontent.com/assets/1697380/20375173/5bafffde-acb8-11e6-8876-0b1e852f918a.jpg)

## Duplicate Google calendars with events

If you ever want to duplicate all existing events from one Google calendar to a new one, this is it.

### Setup
I assume you have Ruby installed

1. Install gems with `bundle install`
2. Make sure you [have/create a project](https://console.developers.google.com/iam-admin/projects) in Google APIs and enable [Calendar API](https://console.developers.google.com/apis/api/calendar-json.googleapis.com/overview)
3. Create an [OAuth Client ID](https://console.developers.google.com/apis/credentials) with application type set to `other`
4. Download credential in JSON file (i.e. `client_secret_xxxx.apps.googleusercontent.com`); move it into the top level of this project folder; rename file name to `client_secret.json`
6. Run `ruby run.rb`
7. You will be asked to "Open the following URL in the browser and enter the resulting code after authorization"
  - Simply go to the given link
  - Allow your own API project to manage your Google Calendar
  - Copy the given code and paste it back to your terminal
8. You are set to go

### Super Power: Duplicate my calendar, please.
1. Run `ruby run.rb`
2. Enter the `URL` of your base calendar
3. Give `Name` of your new calendar
4. Set `Offset` value for events between base and new calendar. The unit is in `days` and the default is `0`.

---

#### By the way, we teach online courses at [Hack Pacific](https://www.hackpacific.com).
