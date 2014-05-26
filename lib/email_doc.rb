require "email_doc/version"
require 'email_doc/documents'
require 'email_doc/document'
require 'rspec'
require 'action_mailer'

module EmailDoc
  def self.documents
    @documents ||= EmailDoc::Documents.new
  end

  def self.included(base)
    RSpec.configuration.after(:each, email_doc: true) do
      mail = ActionMailer::Base.deliveries.last
      EmailDoc.documents.append(self, mail)
    end

    RSpec.configuration.after(:suite) do
      EmailDoc.documents.write
    end
  end
end
