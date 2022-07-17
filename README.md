# roda-turbo

_**WIP:** this plugin will be officially released as part of the Bridgetown 1.2 release cycle later this year. Stay tuned…_

----

This plugin adds [Turbo Streams](https://turbo.hotwired.dev/handbook/streams) support for the [Roda web toolkit](http://roda.jeremyevans.net/). It works in a standard Roda context as well as in [Bridgetown](https://www.bridgetownrb.com).

**NOTE:** This does not add support for async streaming (aka via Websockets, etc.). It simply adds support for stream tags in HTML responses, such as when forms are submitted via Turbo. See [issue #2](https://github.com/bridgetownrb/roda-turbo/issues/2) to track a future implementation. Turbo Frame tag helpers are [also planned](https://github.com/bridgetownrb/roda-turbo/issues/1).

## Installation

This README assumes you know how to install [Turbo's JavaScript library](https://turbo.hotwired.dev/handbook/installing) in your Roda project. The easiest way might be to use the Skypack CDN in your main JavaScript file.

```js
import * as Turbo from "https://cdn.skypack.dev/@hotwired/turbo"
```

If you're using Bridgetown, you can simply run the [Turbo bundled configuration](https://www.bridgetownrb.com/docs/bundled-configurations#turbo).

Once the Turbo frontend is installed, you can run this command to add the roda-turbo gem to your `Gemfile`:

```sh
$ bundle add roda-turbo
```

Then add the plugin to your Roda app:

```rb
class App < Roda
  plugin :turbo
end
```

## Usage

Now you can use the `turbo_stream` helper in a route, and the `turbo_stream?` request method to determine if the incoming request was triggered by a Turbo form submission:

```rb
r.post "stream_this" do
  if r.turbo_stream?
    turbo_stream.append "element-id", "<p>Hello from Turbo!</p>"
  else
    "<p>Just a regular HTML request.</p>"
  end
end
```

If you'd like to return multiple stream actions, just define them within an array and join at the end:

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

### Bridgetown Setup

Add the initializer to your configure block:

```rb
# config/initializers.rb

Bridgetown.configure do
  # configurations…

  init :"roda-turbo"

  # configurations…
end
```

The `turbo_stream` helper will available within routes inside your Bridgetown project as well as Ruby-based templates.

Render parameters (such as in the above example) will be passed to the underlying template engine's `partial` method. You can also inline render components and pass the output to the initial string argument.

```rb
turbo_stream.update "#navbar", render(Public::Navbar.new metadata: bridgetown_site.metadata, resource: resource)
```

## Development

After checking out this repo, run `bin/setup` to install dependencies. Then, run `bin/rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bin/rake install`. To release a new version, update the version number in `roda-turbo.gemspec`, and then run `bin/rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bridgetownrb/roda-turbo. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/bridgetownrb/roda-turbo/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the roda-turbo project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/bridgetownrb/roda-turbo/blob/main/CODE_OF_CONDUCT.md).
