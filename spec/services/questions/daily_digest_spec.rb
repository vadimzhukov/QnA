require 'rails_helper'

RSpec.describe Questions::DailyDigest do
  
  let(:users) { create_list(:user, 3)}
  let(:questions) { create_list(:question,3, created_at: DateTime.now - 1.day, user: users.first) }
  
  it "each user notified via NotificationMailer#questions_digest" do
    users.each { |u| expect(NotificationMailer).to receive(:questions_digest).with(u, questions).and_call_original }
    subject.send_yesterday_questions_digest
  end

end