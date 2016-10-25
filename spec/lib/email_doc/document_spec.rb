require 'helper'

describe EmailDoc::Document do
  let :mailer_class do
    Class.new(ActionMailer::Base) do
      def welcome(email)
        mail \
          to:       email,
          from:     'from@example.org',
          reply_to: 'noreply@example.org',
          subject:  'WELCOME',
          body:     'Welcome to my site.'
      end
    end
  end

  let(:to) { 'to@example.com' }

  let(:mail) { mailer_class.welcome(to) }

  describe '#render' do
    subject { described_class.new(self, mail).render }

    it 'should render document' do
      document_patterns = [
        %r<# #{described_class}>,
        %r<## #{RSpec.current_example.description}>,
        %r<To: \["#{to}"\]>,
        %r<From: \["from@example.org"\]>,
        %r<Reply to: \["noreply@example.org"\]>,
        %r<Subject: WELCOME>,
        %r<Welcome to my site>,
      ]

      document_patterns.each { |regexp| should match regexp }
    end
  end
end
