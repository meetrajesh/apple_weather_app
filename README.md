# README

## How to run app

```
git clone git@github.com:meetrajesh/apple_weather_app.git
cd apple_weather_app
brew install redis
brew services start redis
vi .env # update OpenWeather API key here
bundle install
rails server -p 3000
```

Then navigate to http://127.0.0.1:3000/

## Tests/Specs

```
cd apple_weather_app
bundle install
bundle exec rspec
```

## Screenshots

![image](https://github.com/meetrajesh/apple_weather_app/assets/101797/7e559553-08b8-43da-bc34-8ed07c1aa25f)
