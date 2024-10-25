# frozen_string_literal: true

RSpec.describe Net::SMTP::AuthNTLM do
  describe "#auth" do
    let(:smtp) { double("SMTP") }
    let(:ntlm_available) { true }
    let(:user) { "user" }
    let(:password) { "password" }
    let(:authenticator) { described_class.new(smtp) }

    before do
      expect(smtp).to receive(:auth_capable?).with("NTLM").and_return(ntlm_available)
    end

    context "when NTLM is not available" do
      let(:ntlm_available) { false }

      it "raises an error" do
        expect { authenticator.auth(user, password) }.to raise_error(Net::SMTPAuthenticationError)
      end
    end

    context "when NTLM is available" do
      let(:challenge_init) do
        "NTLMSSP\x00\x01\x00\x00\x00\a\x82\b\x00\x00\x00\x00\x00 \x00\x00\x00\x00\x00\x00\x00 \x00\x00\x00#{Socket.gethostname}" # rubocop:disable Layout/LineLength
      end
      let(:challenge_init_msg) { "AUTH NTLM #{Base64.encode64(challenge_init).strip}" }
      let(:challenge_response) do
        # sample type 2 from https://github.com/WinRb/rubyntlm/blob/master/spec/lib/net/ntlm/message/type2_spec.rb#L22
        Net::SMTP::Response.parse("334 TlRMTVNTUAACAAAAHAAcADgAAAAFgooCJ+UA1//+ZM4AAAAAAAAAAJAAkABUAAAABgGxHQAAAA9WAEEARwBSAEEATgBUAC0AMgAwADAAOABSADIAAgAcAFYAQQBHAFIAQQBOAFQALQAyADAAMAA4AFIAMgABABwAVgBBAEcAUgBBAE4AVAAtADIAMAAwADgAUgAyAAQAHAB2AGEAZwByAGEAbgB0AC0AMgAwADAAOABSADIAAwAcAHYAYQBnAHIAYQBuAHQALQAyADAAMAA4AFIAMgAHAAgAZBMdFHQnzgEAAAAA") # rubocop:disable Layout/LineLength
      end
      let(:finish_response) do
        Net::SMTP::Response.parse("235 ALL GOOD")
      end

      it "performs the NTLM auth" do
        expect(smtp).to receive(:get_response).with(challenge_init_msg).and_return(challenge_response).ordered
        expect(smtp).to receive(:get_response).and_return(finish_response).ordered.with(lambda { |auth_msg|
          msg = Net::NTLM::Message.decode64(auth_msg)
          expect(msg).to be_a(Net::NTLM::Message::Type3)
        })
        result = authenticator.auth(user, password)
        expect(result.success?).to be_truthy
      end
    end
  end
end
