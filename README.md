# README

## Setup

### ENV

Create an `.env` file at the root of the project and add the following environment variables to the file:

* `OPEN_WEATHER_API_KEY` -- API key for https://openweathermap.org/api
* `GEOAPIFY_ADDRESS_AUTOCOMPLETE_API_KEY` -- API key for https://apidocs.geoapify.com/

### Database

This project uses PostgreSQL v16

### Homebrew and Oh My Zsh

Install PostgreSQL:
```
brew install postgresql@16
echo 'export PATH="/opt/homebrew/opt/postgresql@16/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

Start the service and create the database:
```
brew services start posgresql@16
bin/rails db:create
```

### Starting the Local Server

This project uses tailwind as its CSS processor, which must be compiled before changes can be seen in the application. TW has a just-in-time compiler for development that must run alongside the rails server.

When starting the local server, make sure to run:

`bin/dev`

## Applicant Follow-Up Work Ideas

* Determine whether it's necessary (and if so how) to create better security for the API tokens
* Replace complex JS with PORO Models & Hotwire to render more complex and readable UI code
* Replace Ruby caching with Redis caching
* Add support for metric units with a FE toggle

## Assignment Parameters

### Coding Assignment Requirements:

· Must be done in Ruby on Rails

· Accept an address as input

· Retrieve forecast data for the given address. This should include, at minimum, the current temperature (Bonus points - Retrieve high/low and/or extended forecast)

· Display the requested forecast details to the user

· Cache the forecast details for 30 minutes for all subsequent requests by zip codes. Display indicator if result is pulled from cache.

### Assumptions:

· This project is open to interpretation

· Functionality is a priority over form

· If you get stuck, complete as much as you can

### Submission:

· Use a public source code repository (GitHub, etc) to store your code

· Send us the link to your completed code

### Reminders:

Please remember – it’s not just whether or not the code works that they will be focused on seeing – it’s all the rest of what goes into good Senior Software Engineering daily practices for Enterprise Production Level Code – such as specifically:

· Unit Tests (#1 on the list of things people forget to include – so please remember, treat this as if it were true production level code, do not treat it just as an exercise),

· Detailed Comments/Documentation within the code, also have a README file

· Include *Decomposition* of the Objects in the Documentation

· Design Patterns (if/where applicable)

· Scalability Considerations (if applicable)

· Naming Conventions (name things as you would name them in enterprise-scale production code environments)

· Encapsulation, (don’t have 1 Method doing 55 things)

· Code Re-Use, (don’t over-engineer the solution, but don’t under-engineer it either)

· and any other industry Best Practices.

· Remember to Include the UI ***

· No not use ChatGPT/AI
