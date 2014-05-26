require 'email_doc'

module EmailDoc
  class Documents
    def initialize
      @table = Hash.new {|table, key| table[key] = []}
    end
 
    def append(context, mail)
      document = EmailDoc::Document.new(context.clone, mail.clone)
      @table[document.pathname] << document
    end
 
    def write
      @table.each do |pathname, documents|
        pathname.parent.mkpath
        pathname.open("w") do |file|
          file << documents.map(&:render).join("\n")
        end
      end
    end
  end
end
