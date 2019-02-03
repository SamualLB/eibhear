module Eibhear::Base
  macro included
    macro finished
      __process_eibhear
    end
  end

  macro included
    EIBHEAR_FIELDS = [] of Nil
    EIBHEAR_TABLE = {name: translations, klass: nil, foreign_key: nil}
  end

  macro __process_eibhear
    class_getter eibhear_class = {{EIBHEAR_TABLE[:klass]}}

    getter eibhear_translations = {} of String => {{EIBHEAR_TABLE[:klass]}}

    def all_{{EIBHEAR_TABLE[:name]}}
      collection = {{EIBHEAR_TABLE[:name]}}.all
      collection.each do |row|
        @eibhear_translations[row.locale!] = row
      end
      eibhear_translations
    end

    {% for field in EIBHEAR_FIELDS %}
      {% suffixes = field[:raise_on_nil] ? ["?".id, "".id] : ["".id, "!".id] %}

      # Standard
      def {{field[:name]}}{{suffixes[0]}}(force_locales : Array(String)? = nil) : {{field[:type]}}?
        force_locales = Eibhear.config.available_locales if force_locales.nil? || force_locales.empty?
        force_locales.each do |locale|
          if cached = eibhear_translations[locale]?
            return cached.{{field[:name]}}!
          end
          if result = {{EIBHEAR_TABLE[:name]}}[locale]?
            @eibhear_translations[locale] = result
            return result.{{field[:name]}}!
          end
        end
        nil
      end

      def {{field[:name]}}{{suffixes[1]}}(force_locales : Array(String)? = nil) : {{field[:type]}}
        {{field[:name]}}{{suffixes[0]}}(force_locales) || raise "Could not find '{{field[:name]}}' in #{force_locales}"
      end

      # Splats
      def {{field[:name]}}{{suffixes[0]}}(*force_locales : String) : {{field[:type]}}?
        {{field[:name]}}{{suffixes[0]}} force_locales.to_a
      end

      def {{field[:name]}}{{suffixes[1]}}(*force_locales : String) : {{field[:type]}}
        {{field[:name]}}{{suffixes[1]}} force_locales.to_a
      end

      # Standard with locale
      def {{field[:name]}}_with_locale{{suffixes[0]}}(force_locales : Array(String)? = nil) : Tuple({{field[:type]}}, String)?
        force_locales = Eibhear.config.available_locales if force_locales.nil? || force_locales.empty?
        force_locales.each do |locale|
          if cached = eibhear_translations[locale]?
            return {cached.{{field[:name]}}!, locale}
          end
          if result = {{EIBHEAR_TABLE[:name]}}[locale]?
            @eibhear_translations[locale] = result
            return {result.{{field[:name]}}!, locale}
          end
        end
        nil
      end

      def {{field[:name]}}_with_locale{{suffixes[1]}}(force_locales : Array(String)? = nil) : Tuple({{field[:type]}}, String)
        {{field[:name]}}_with_locale{{suffixes[0]}}(force_locales) || raise "Could not find '{{field[:name]}}' in #{force_locales}"
      end

      # Splats with locale
      def {{field[:name]}}_with_locale{{suffixes[0]}}(*force_locales : String) : Tuple({{field[:type]}}, String)?
        {{field[:name]}}_with_locale{{suffixes[0]}} force_locales.to_a
      end

      def {{field[:name]}}_with_locale{{suffixes[1]}}(*force_locales : String) : Tuple({{field[:type]}}, String)
        {{field[:name]}}_with_locale{{suffixes[1]}} force_locales.to_a
      end

    {% end %}
  end

  macro has_translations(table, *fields, **options)
    {% EIBHEAR_TABLE[:name] = table.id %}
    {% if table.is_a? Path %}
      {% EIBHEAR_TABLE[:klass] = table.id %}
    {% else %}
      {% if table.is_a? TypeDeclaration %}
        {% EIBHEAR_TABLE[:name] = table.var.id %}
        {% EIBHEAR_TABLE[:klass] = table.type %}
      {% else %}
        {% EIBHEAR_TABLE[:name] = table.id %}
        {% EIBHEAR_TABLE[:klass] = table.id.camelcase %}
      {% end %}
    {% end %}
    
    # Process fields
    {% for field in fields %}
      {% EIBHEAR_FIELDS << {name: field.id, type: String, raise_on_nil: false} %}
      {% if EIBHEAR_FIELDS.last[:name].ends_with? '!' %}
        {% EIBHEAR_FIELDS.last[:raise_on_nil] = true %}
        {% EIBHEAR_FIELDS.last[:name] = EIBHEAR_FIELDS.last[:name][0...-1] %}
      {% end %}
      {% if field.is_a? TypeDeclaration %}
        {% EIBHEAR_FIELDS.last[:type] = field.type %}
      {% end %}
    {% end %}

    # Process options
    {% EIBHEAR_TABLE[:foreign_key] = options[:foreign_key] || @type.stringify.split("::").last.underscore + "_id" %}

    def {{EIBHEAR_TABLE[:name]}}
      Eibhear::AssociationCollection(self, {{EIBHEAR_TABLE[:klass]}}).new(self, {{EIBHEAR_TABLE[:foreign_key]}})
    end
  end
end
