# frozen_string_literal: true

require "net/smtp"
require "rubyntlm"

class Net::SMTP
  # Provides NTLM authentication for Net::SMTP.
  # based on example from https://github.com/WinRb/rubyntlm/blob/master/examples/smtp.rb and
  # old Net::SMTP NTLM implementation from https://github.com/macks/ruby-ntlm/blob/master/lib/ntlm/smtp.rb
  class AuthNTLM < Net::SMTP::Authenticator
    auth_type :ntlm

    def auth(user, secret)
      raise Net::SMTPAuthenticationError, "NTLM not supported" unless smtp.auth_capable?("NTLM")

      domain, user = if user.index("\\")
                       user.split("\\", 2)
                     else
                       ["", user]
                     end

      perform_auth(user, domain, secret)
    end

    private

    def perform_auth(user, domain, password)
      t1 = Net::NTLM::Message::Type1.new
      challenge = continue("AUTH NTLM #{t1.encode64}")
      t2 = Net::NTLM::Message.decode64(challenge)
      t3 = t2.response({ user: user, password: password, domain: domain }, {})

      finish(t3.encode64)
    end
  end
end
