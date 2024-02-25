module Api
  module Iterable
    class Email < Base
      def send_email!(user_id,
                      campaign_id,
                      data_fields: {},
                      send_at: Time.zone.now,
                      allow_repeat_marketing_sends: true,
                      metadata: {})
        body = {
          campaignId: campaign_id,
          recipientUserId: user_id,
          dataFields: data_fields,
          sendAt: send_at.strftime('%Y-%m-%d %H:%M:%S'),
          allowRepeatMarketingSends: allow_repeat_marketing_sends,
          metadata: metadata,
        }

        post_call!('/api/email/target', body)
      end
    end
  end
end
