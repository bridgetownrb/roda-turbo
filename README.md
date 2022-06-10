# roda-turbo

[Turbo Streams](https://turbo.hotwired.dev/handbook/streams) support for the [Roda web toolkit](http://roda.jeremyevans.net/). It works in a standard Roda context as well as in [Bridgetown](https://www.bridgetownrb.com).

## Installation

Run this command to add the gem to your `Gemfile`:

```sh
$ bundle add roda-turbo

# or if you're installing in a Bridgetown site:
$ bundle add roda-turbo -g bridgetown_plugins
```

## Usage

Add the plugin to your Roda app:

```rb
class App < Roda
  plugin :turbo
end
```

Now you can use the `turbo_stream` helper in a route, and the `turbo_stream?` request method to determine if the incoming request was triggered by a Turbo form:

```rb
r.post "stream_this" do
  if r.turbo_stream?
    turbo_stream.append "element-id", "<p>Hello from Turbo!</p>"
  else
    "<p>Just a regular HTML request.</p>"
  end
end
```

If you'd like to return multiple stream actions, just add them to an array and join at the end:

```rb
r.post do
  [
    turbo_stream.append_all(".content", "<p>Content goes here.</p>"),
    turbo_stream.replace_all("header", "<h1>Header Title</h1>")
  ].join
end
```

You can also use the `turbo_stream` helper in Roda views, along with `render` parameters.

```erb
<%= turbo_stream.update "#el", template: "content_partial", locals: { foo: "bar" } %>
```

### Bridgetown

The `turbo_stream` helper is available within Roda routes inside your Bridgetown project as well as Ruby-based templates.

Render parameters (such as in the above example) will be passed to the underlying template engine's `partial` method. (Note: this only works in Bridgetown 1.1 or later.) You can also inline render components and pass the output to the initial string argument.

```erb
<%= turbo_stream.update "#navbar", render(Public::Navbar.new metadata: site.metadata, resource: resource) %>
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `roda-turbo.gemsepc`, and then run `bin/rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bridgetownrb/roda-turbo. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/bridgetownrb/roda-turbo/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the roda-turbo project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/bridgetownrb/roda-turbo/blob/main/CODE_OF_CONDUCT.md).
