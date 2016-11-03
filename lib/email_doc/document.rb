require 'email_doc'
require 'forwardable'

module EmailDoc
  class Document
    extend Forwardable

    attr_reader :mail, :context, :ex

    def_delegators :mail, :subject, :from, :to, :reply_to, :body
    def_delegators :context, :described_class

    def initialize(context, mail, ex)
      @context = context
      @mail    = mail
      @ex      = ex
    end

    def render
      ERB.new(<<-MD_END).result(binding)
# #{described_class}

## #{ex.description}

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
        path = ex.file_path.gsub(%r<\./spec/mailers/(.+)_spec\.rb>, '\1.md')
        Pathname.new(dir + path)
      end
    end
  end
end
