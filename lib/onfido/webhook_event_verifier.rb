require "json"
require "openssl"

module Onfido
  class OnfidoInvalidSignatureError < StandardError; end

  class WebhookEventVerifier
    def initialize(webhook_token)
      @webhook_token = webhook_token
    end

    def read_payload(event_body, signature)
      event_signature = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), @webhook_token, event_body)

      raise(OnfidoInvalidSignatureError, "Invalid signature for webhook event") unless OpenSSL.secure_compare(signature, event_signature)

      WebhookEvent.build_from_hash(JSON.parse(event_body))
    end
  end
end