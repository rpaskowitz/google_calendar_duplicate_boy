require 'google/apis/calendar_v3'
require 'googleauth'
require 'googleauth/stores/file_token_store'
require 'date'
require 'fileutils'

OOB_URI = 'urn:ietf:wg:oauth:2.0:oob'.freeze
APPLICATION_NAME = 'Google Calendar Dupicate Boy'.freeze
CLIENT_SECRETS_PATH = 'client_secret.json'.freeze
CREDENTIALS_PATH = File.join(Dir.home, '.credentials', 'calendar-ruby-quickstart.yaml')
# SCOPE = Google::Apis::CalendarV3::AUTH_CALENDAR_READONLY
SCOPE = Google::Apis::CalendarV3::AUTH_CALENDAR

##
# Ensure valid credentials, either by restoring from the saved credentials
# files or intitiating an OAuth2 authorization. If authorization is required,
# the user's default browser will be launched to approve the request.
#
# @return [Google::Auth::UserRefreshCredentials] OAuth2 credentials
def authorize
  FileUtils.mkdir_p(File.dirname(CREDENTIALS_PATH))

  client_id = Google::Auth::ClientId.from_file(CLIENT_SECRETS_PATH)
  token_store = Google::Auth::Stores::FileTokenStore.new(file: CREDENTIALS_PATH)
  authorizer = Google::Auth::UserAuthorizer.new(
    client_id, SCOPE, token_store)
  user_id = 'default'
  credentials = authorizer.get_credentials(user_id)
  if credentials.nil?
    url = authorizer.get_authorization_url(
      base_url: OOB_URI)
    puts 'Open the following URL in the browser and enter the ' +
         'resulting code after authorization'
    puts url
    code = gets
    credentials = authorizer.get_and_store_credentials_from_code(
      user_id: user_id, code: code, base_url: OOB_URI)
  end
  credentials
end

def new_event(calendar_id, summary, description, start_time, end_time, timezone)
  event = Google::Apis::CalendarV3::Event.new({
    summary: summary,
    description: description,
    start: {
      date_time: start_time,
      time_zone: timezone
    },
    end: {
      date_time: end_time,
      time_zone: timezone
    }
  })

  result = $service.insert_event(calendar_id, event)
  puts "Event created: #{result.html_link}"
end

def new_calendar(name, time_zone)
  future_cal = Google::Apis::CalendarV3::Calendar.new(
    summary: name,
    time_zone: time_zone
  )
  $service.insert_calendar(future_cal)
end

def copy_events(base_cal, new_cal, offset_days = 0)
  return puts 'No events found' if base_cal.items.empty?
  base_cal.items.each do |event|
    new_start_time = event.start.date_time + offset_days
    new_end_time = event.end.date_time + offset_days
    new_event(new_cal.id, event.summary, event.description, new_start_time.iso8601, new_end_time.iso8601, 'Asia/Hong_Kong')
  end
end

# Initialize the API
$service = Google::Apis::CalendarV3::CalendarService.new
$service.client_options.application_name = APPLICATION_NAME
$service.authorization = authorize

puts 'URL of base calendar'
base_cal = $service.list_events(gets.chomp, single_events: true, order_by: 'startTime', time_min: '1970-01-01T00:00:00Z')

puts 'Name of your new calendar'
new_cal = new_calendar(gets, base_cal.time_zone)

puts 'Set your offsets in days (default: 0)'
days_of_offsets = gets
copy_events(base_cal, new_cal, days_of_offsets.to_i)

puts 'DONE!'
