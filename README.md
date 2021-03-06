# CouncilLookup

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/council_lookup`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'council_lookup', git: 'https://github.com/kuzmenkonikolay/council_lookup'
```

And then execute:

    $ bundle install

Download council db:

    $ rake download:db

## Usage

```
@db = CouncilLookup.connect
council = @db.find(postcode)
```

There is such methods like: 
```
insert(postcode, name, country_code, country_name, local_authority_code)
where(array_of_postcodes)
pluck(column, array_of_postcodes)
all_count
find_by(postcode: postcode)
update(postcode, column, value)
delete(postcode)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/council_lookup. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the CouncilLookup project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/council_lookup/blob/master/CODE_OF_CONDUCT.md).
