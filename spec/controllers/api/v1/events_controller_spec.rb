require 'rails_helper'

RSpec.describe Api::V1::EventsController, type: :controller do
  let(:current_user_id) { Faker::Internet.uuid }
  let(:event_name) { UserEngagementService.valid_event_names.sample }
  let(:data_fields) { { key: 'value' } }

  before do
    allow(controller).to receive(:current_user_id).and_return(current_user_id)
  end

  describe 'POST #create' do
    let(:user_engagement_service) { instance_double(UserEngagementService) }

    context 'with valid params' do
      let(:params) { { event: { name: event_name, data_fields: data_fields } } }

      before do
        Timecop.freeze
      end

      after do
        Timecop.return
      end

      it 'calls UserEngagementService#track_event!' do
        expect(UserEngagementService).to receive(:new)
                                           .with(current_user_id)
                                           .and_return(user_engagement_service)
        expect(user_engagement_service).to receive(:track_event!)
                                             .with(event_name, Time.zone.now, data_fields)

        post :create, params: params

        expect(response).to have_http_status(:ok)
        expect(response.body).to eq({ data: {}, errors: nil, message: 'Event received.' }.to_json)
      end
    end

    context 'with invalid params' do
      let(:params) { { event: {} } }

      it 'returns status 400 and error message' do
        post :create, params: params

        expect(response).to have_http_status(:bad_request)
        expect(response.body).to include('param is missing or the value is empty: event')
      end
    end
  end
end
