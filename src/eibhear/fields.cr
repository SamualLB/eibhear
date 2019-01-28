module Eibhear::Fields
  # Reset for next include
  macro included
    macro included
      I18N_FIELDS = {} of Nil => Nil
    end
  end

  macro i18n_field(decl, **options)
    {% I18N_FIELDS[decl.id] = options || {} of Nil => Nil %}
    {% I18N_FIELDS[decl.id][:type] = String %}
  end

  macro i18n_field!(decl, **options)
    i18n_field {{decl}}, {{options.double_splat(", ")}}raise_on_nil: true
  end

  macro __process_i18n_fields
    {% for name, options in I18N_FIELDS %}
      {% type = options[:type] %}
      {% suffixes = options[:raise_on_nil] ? ["?", ""] : ["", "!"] %}

      # From granite/fields.cr:44
      #
      # Override options after settings required variables
      # to get to the user supplied options
      {% if options[:options] %}
        {% options = options[:options] %}
      {% end %}

      # From granite/fields.cr:51
      #
      # Set each user supplied annotation on the property
      {% if options[:annotations] %}
        {% for ann in options[:annotations] %}
          {{ann.id}}
        {% end %}
      {% end %}

      # From granite/fields.cr:57
      #
      # Apply JSON/YAML serialization option annotations
      {% if options[:json_options] %}
        @[JSON::Field({{**options[:json_options]}})]
      {% end %}
      {% if options[:yaml_options] %}
        @[YAML::Field({{**options[:yaml_options]}})]
      {% end %}

      # Create methods for accessing translations

      # Access using default locale
      def {{name.id}}(force_locale : String? = nil)
        {{name.id}} force_locale ? [force_locale] : [] of String
      end

      def {{name.id}}(locales : Array(String))
        if locales.empty?
          # fill with default from config
        end
        locales.each do |locale|
          row = {{@@eibhear_class.name}}.find_by(test_field: "test_value")
          #row = @@eibhear_class.find_by({{@type.name}}.primary_name(): {{@type.name}}.primary_name)
        end
        nil
      end

      def {{name.id}}!(force_locale : String? = nil)
        {{name.id}}! force_locale ? [force_locale] : [] of String
      end

      def {{name.id}}!(locales : Array(String))
        raise "Property '{{name.id}}' not found in locale: #{locales}" unless {{name.id}}(locales)
      end

    {% end %}

    # From granite/fields.cr:76
    #
    # Keep a hash of the fields to be used for mapping
    #disable_eibhear_docs?
    def self.i18n_fields : Array(String)
      @@fields ||= {{ I18N_FIELDS.empty? ? "[] of String".id : I18N_FIELDS.keys.map(&.id.stringify) }}
    end

    # From granite/fields.cr:85
    #
    # Keep a hash of the params that will be passed to the adapter
    disable_eibhear_docs? def i18n_values
      parsed_params = [] of Granite::Fields::Type
      {% for name, options in I18N_FIELDS %}
        parsed_params << {{name.id}}
      {% end %}
      return parsed_params
    end

    # TODO: This will have to override
    #disable_eibhear_docs? def to_h
    #end
  end
end
