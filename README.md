# ControlledVocabulary
This plugin was designed to make it easy to implement dropdown menus with customizable options.

## Usage
Include the `Referrable` concern in any model.

```ruby
class Artwork < ApplicationRecord
  include ControlledVocabulary::Referrable
  
  references :location, required: true # Louvre, Museum of Modern Art, etc
  references :awards, multiple: true # 
end
```

If using the [resource-api](https://github.com/performant-software/resource-api) gem, it is a good idea to `preload` any references in your controller that will be serialized for optimal performance. Also include the `Queryable` concern for easy searching and sorting.
```ruby
class Api::ArtworksController < Api::BaseController
  include ControlledVocabulary::Queryable
  
  preloads location: :reference_code
  preloads awards: :reference_code
end
```

Include the `ControlledVocabulary::ReferrableSerializer` in your serializer to automatically include your reference values.
```ruby
class ArtworksSerializer < BaseSerializer
  include ControlledVocabulary::ReferrableSerializer
  
  index_attributes :id, :name, :location
  show_attribtues :id, :name, :location, :awards
end
```

`POST http://localhost:3001/artworks`

```json
{
  "artwork": {
    "location": [
      {
        "reference_code_id": 1
      }
    ],
    "awards": [
      {
        "reference_code_id": 56
      },
      {
        "reference_code_id": 4
      }
    ]
  }
}
```

`GET http://localhost:3001/artworks/1`

```json
{
  "artwork": {
    "awards": [
      {
        "id": 1,
        "key": "awards",
        "reference_code_id": 56
      },
      {
        "id": 2,
        "key": "awards",
        "reference_code_id": 4
      }
    ],
    "awards_view": "Award A, Award B",
    "location": [
      {
        "id": 3,
        "key": "location",
        "reference_code_id": 1
      }
    ],
    "location_view": "Boston, MA"
  }
}
```

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'controlled_vocabulary', git: 'https://github.com/performant-software/controlled_vocabulary.git', tag: 'v0.1.0'
```

And then execute:
```bash
$ bundle install
```

Or install it yourself as:
```bash
$ gem install controlled_vocabulary
```

Execute the follow to copy the necessary migrations into your application.

```bash
$ bundle exec rails controlled_vocabulary:install:migrations
```

Run the migrations.

```bash
$ bundle exec rake db:migrate
```

Add the following to your `routes.rb` file to add routes:

```ruby
Rails.application.routes.draw do
  mount ControlledVocabulary::Engine, at: "/controlled_vocabulary"

  # ...other routes
end
```

Optional: Update the controllers to extend your base controller. Add a file called `/initializers/controlled_vocabulary.rb` with the following:

```ruby
ControlledVocabulary.configure do |config|
  config.base_controller = 'Api::BaseController'
end
```

This will allow all of the controllers within this engine to extend the base controller from your application. It will allow for any `before_action` calls to be executed, such as authentication.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
