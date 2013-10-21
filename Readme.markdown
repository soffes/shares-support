# Shares Support

This repository contains the supporting files and artwork for [Shares](http://getsharesapp.com). It's primary job is to caches the exchange rate API and combine it with more configuration and upload to S3 in a unified file. The app access this file on S3 occasionally to see if there is new content.

This is deployed to Heroku. `bundle exec rake update` is executed every hour to make sure things stay up to date.

## Data

When updating [artwork.json](data/artwork.json) or [exchanges.json](data/exchanges.json), you **must** update the `updated_at` value or the app will ignore the change. I just open up `irb` and copy `Time.now.to_i` into the value.

[currencies.json](data/currencies.json) is automatically updated with the script, so there isn't an `updated_at` key in that file.

## Artwork

### Logo

I get logos from [Brand of the World](http://www.brandsoftheworld.com). The maximum size is 300x96. I export a solid white version from Sketch as a PDF so it is scaleable later.


### Hero Image

I Google around (setting the greater than 1024x768 option helps a lot) for a cool image for the company. Usually I search for something like "Apple headquarters." Resize the image to 660x440 and apply a gaussian blur with a 6px radius.

Make sure the the image isn't too light since a white logo will go on top. Sometime, I apply a black layer on top with 3–5% opacity.
