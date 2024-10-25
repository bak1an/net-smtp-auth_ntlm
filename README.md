# Net::SMTP::AuthNTLM

`Net::SMTP::Authenticator` implementation for NTLM authentication based on [rubyntlm](https://github.com/WinRb/rubyntlm) gem.

Does the same thing as [ruby-ntlm](https://github.com/macks/ruby-ntlm) gem did but works out of the box with modern `net-smtp` and `openssl`.

## Installation

Just add it to your Gemfile:

```ruby
gem "net-smtp-auth_ntlm"
````

## Usage

```ruby
require "net/smtp/auth_ntlm"
```

And you can use `:ntlm` as authtype in `Net::SMTP.start` or your mailer configuration.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bak1an/net-smtp-auth_ntlm.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
