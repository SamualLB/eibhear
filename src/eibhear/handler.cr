require "http/server/handler"

class Eibhear::Handler
  include HTTP::Handler
  HEADER = "Accept-Language"

  def call(context)
    if languages = context.request.headers[Citrine::I18n::Handler::HEADER]?
      parser = Citrine::I18n::Parser.new languages
      old = context.locales.clone
      context.locales.clear
      headers = context.request.headers[HEADER]
      parse_languages(headers).each do |loc|
        context.locales << loc if Eibhear.config.available_locales.includes?(loc)
      end
      context.locales = old if context.locales.empty?
    end
    call_next(context)
  end

  # Taken from citrine-i18n/parser.cr:23
  def self.parse_languages(header)
    begin
      header.to_s.gsub(/\s+/, "").split(",").map do |language|
        split = language.split(";q=")
        locale, quality = split[0], split[1]?
        raise ArgumentError.new "Not correctly formatted" unless locale =~ /^[a-z\-0-9]+|\*$/i

        locale = locale.downcase.gsub(/-[a-z0-9]+$/i, &.upcase)
        locale = nil if locale == "*"

        quality = quality ? quality.to_f : 1.0

        {locale, quality}
      end.sort do |(_, left), (_, right)|
        right <=> left
      end.map(&.first).compact
    rescue ArgumentError
      [] of String
    end
  end
end
