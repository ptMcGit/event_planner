# Event Planner

Store events, and show weather forecast for the event date.

## Components

### Event Planner

- event_planner.rb -- main app
- ep_tests.rb

- delete events
- modifying state "upcoming/not_pending"

#### Event Class

#### User Class

- location

### Weather (Wunderground)

- weather_data.rb -- talk to Wunderground API
- w_tests.rb

### Shared Classes

#### Raw Forecast

### RawForecast Class

Carries temperature (F and C (high and low)),  rain percentage, date, location?

Wunderground data

- @celsius an array with [high, low]
- @fahrenheit an array with [high, low]
- @rain_chance
- date_in_sec
- zip code

#### Methods

- to_h              ?
- to_s              ?
- to_yyyy_mm_dd     ? and other date formats?

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

- RawForcast
  -


##########

- Event planner requests weather forecast
- Weather

- Wunderground API date format? YYYY-MM-DD?
