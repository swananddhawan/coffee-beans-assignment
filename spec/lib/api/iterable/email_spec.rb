require 'rails_helper'

RSpec.describe Api::Iterable::Email do
  describe '#send_email!' do
    let(:user_id) { Faker::Internet.uuid }
    let(:campaign_id) { 1 }
    let(:data_fields) { { name: 'John Doe' } }
    let(:send_at) { Time.new(2024, 2, 29, 10, 30, 15) }
    let(:allow_repeat_marketing_sends) { true }
    let(:metadata) { { category: 'marketing' } }

    let(:expected_body)  do
      {
        campaignId: campaign_id,
        recipientUserId: user_id,
        dataFields: data_fields,
        sendAt: send_at.strftime('%Y-%m-%d %H:%M:%S'),
        allowRepeatMarketingSends: allow_repeat_marketing_sends,
        metadata: metadata
      }
    end

    it 'sends an email with the provided parameters' do
      allow(subject).to receive(:post_call!)

      subject.send_email!(user_id,
                          campaign_id,
                          data_fields: data_fields,
                          send_at: send_at,
                          allow_repeat_marketing_sends: allow_repeat_marketing_sends,
                          metadata: metadata)

      expect(subject).to have_received(:post_call!).with('/api/email/target', expected_body)
    end
  end
end
