require 'email_doc'
require 'forwardable'

module EmailDoc
  class Document
    extend Forwardable

    attr_reader :mail, :context

    def_delegators :mail, :subject, :from, :to, :reply_to, :body
    def_delegators :context, :described_class
    def_delegators :example, :description

    def initialize(context, mail)
      @context = context
      @mail    = mail
    end

    def render
      ERB.new(<<-MD_END).result(binding)
# #{described_class}

## #{RSpec.current_example.description}

```
    From: #{from}
 Subject: #{subject}
      To: #{to}
Reply to: #{reply_to}
```

```
#{body.encoded}
```
MD_END
    end

    def pathname
      @pathname ||= begin
        dir  = './doc/mail/'
        path = RSpec.current_example.file_path.gsub(%r<\./spec/mailers/(.+)_spec\.rb>, '\1.md')
        Pathname.new(dir + path)
      end
    end
  end
end
