require 'rails_helper'

RSpec.describe QuestionsDigestNotificationJob, type: :job do
  let(:service) { double("Questions::DailyDigest") }

  before do
    allow(Questions::DailyDigest).to receive(:new).and_return(service) 
  end

  it "calls Questions::DailyDigest#send_yesterday_questions_digest" do
    expect(service).to receive(:send_yesterday_questions_digest)
    QuestionsDigestNotificationJob.perform_now
  end
end