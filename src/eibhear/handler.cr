require "http/server/handler"
require "citrine-i18n"

class Eibhear::Handler
  include HTTP::Handler

  def call(context)
    if languages = context.request.headers[Citrine::I18n::Handler::HEADER]?
      parser = Citrine::I18n::Parser.new languages
      old = context.locales.clone
      context.locales.clear    
      parser.user_preferred_languages.each do |loc|
        context.locales << loc if Eibhear.config.available_locales.includes?(loc)
      end
      context.locales = old if context.locales.empty?
    end
    call_next(context)
  end
end
