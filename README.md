# Event Planner

Store events, and show weather forecast for the event date.

## Components

### Event Planner

- event_planner.rb -- main app
- ep_tests.rb

- delete events
- modifying state "upcoming/not_pending"

#### Event Class

Holds data about event and forecasts per hour?

- @title
- @date         - in seconds
- @duration_sec - in 3600 second increments?
- @zip_code


#### User Class

- location

### Weather (Wunderground)

- weather_data.rb -- talk to Wunderground API
- w_tests.rb

### Shared Classes

#### Raw Forecast

### RawForecast Class

From Wunderground data

- @ctemp_day_hilo  an array with [high, low]
- @ftemp_day_hilo an array with [high, low]
- @rain_chance
- @date_of_event
- @born_on_date
- @zip_code
- @ctemp_event_hour
- @ftemp_event_hour

#### Methods

- to_h              ?
- to_s              ?
- to_yyyy_mm_dd     ? and other date formats?

- #get_best_forecast

  - checks current date vs. event date
  - chooses appropriate method:

    - #beyond_10
    - #10_to_3
    - #under_3


## Inter-app Communication?

- Location passed around in zip code?

- Time passed around in seconds

        # as string and different formats

        a = Time.new
        a.strftime(%s)

        # epoch format straight away

        a.tv_sec

- Temperature passed as Celsius


- All numbers to be passed as integers? Strings?

    - Percentage rain chance
    - Date/time
    - Temperature

##########

- Event planner requests weather forecast
- Weather

- Wunderground API date format? YYYY-MM-DD?
