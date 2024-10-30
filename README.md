# Project: Weather Forecast

## Overview

A Ruby on Rails application that utilizes location and weather data from [Open Meteo][open meteo]
to display the relevant forecast data to the user.

## Technologies

* Ruby 3.3
* Rails 7.2
* Redis 7

## Notable Features

* Utilizes [HotWire][hot wire] to act as a single page application.
* CSS provided by [SimpleCSS][simple css].
* Code style enforced by [RuboCop][rubo cop].
* Code coverage provided by [SimpleCov][simple cov].

## Running the Test Suite

The unit tests are written in RSpec and can be run with the following command:

```sh
bundle exec rspec
```

## Example Usage

### 1. Searching For A Location

When loading the app, you will see an input requesting a City or Postal Code.

![Search Form][search form image]

### 2. Selecting A Location

Upon entering a city, and clicking the Search button, a list of related locations will be displayed.

![Search Results][search results image]

### 3. Viewing A Forecast

Clicking on a location will display the forecast for that location.

![Forecast][forecast image]

### Cached Data

Data on both the Location Selection screen and the Forecast screen may be cached for up to 30 minutes.

The data has been retrieved from the cache when the _displaying cached results_ text appears at the bottom of the page.

## Object Overview

### `OpenMeteo::Location`

**Location:** `app/services/open_meteo/location.rb`
**Specs:** `specs/services/open_meteo/location_spec.rb`

Responsible for interfacing with Open Meteo's location API to provide a list of options for the data entered by a user.

Open Meteo's forecast API requires longitude and latitude, therefore it was necessary to convert the user data into a list of options
that they can select from. It's even more important since the user can enter many different types of data
(city + state, zipcode, province + country, etc).

The location API response is cached in Redis for 30 minutes.

### `OpenMeteo::Forecast`

**Location:** `app/services/open_meteo/forecast.rb`
**Specs:** `specs/services/open_meteo/forecast_spec.rb`

Responsible for interfacing with Open Meteo's forecast API. It requires a longitude and latitude, as well as a temperature_unit (defaults to fahrenheit).

The forecast API response is cached in Redis for 30 minutes.

## Required Environment Variables

* `REDIS_URL`

[open meteo]: https://open-meteo.com/
[hot wire]: https://hotwired.dev/
[simple css]: https://simplecss.org/
[rubo cop]: https://rubocop.org/
[simple cov]: https://rubygems.org/gems/simplecov
[search form image]: docs/search_form.png
[search results image]: docs/search_results.png
[forecast image]: docs/forecast.png
