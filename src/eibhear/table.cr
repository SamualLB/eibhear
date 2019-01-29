module Eibhear::Table
  # Reset for next include
  macro included
    macro included
      disable_eibhear_docs? EIBHEAR_SETTINGS = {} of Nil => Nil
    end
  end

  # Override?
  macro eibhear_adapter(name)
    {% EIBHEAR_SETTINGS[:adapter] = name.id %}
  end

  # Specify table name for the translation table,
  # otherwise will be built from table name
  macro eibhear_table_name(name)
    {% EIBHEAR_SETTINGS[:table_name] = name.id %}
  end

  # Specify class name for translation model,
  # otherwise it will use Translation
  macro eibhear_class_name(name)
    {% EIBHEAR_SETTINGS[:class_name] = name.id %}
  end

  macro __process_i18n_table
    {% name_space = @type.name.gsub(/::/, "_").id + "_Translation" %}
    {% table_name = EIBHEAR_SETTINGS[:table_name] || name_space.underscore %}
    {% class_name = EIBHEAR_SETTINGS[:class_name] || "Translation".id %}
    @@eibhear_table_name = "{{table_name}}"
    class_getter eibhear_class = {{class_name}}

    disable_eibhear_docs? def self.eibhear_table_name
      @@eibhear_table_name
    end

    disable_eibhear_docs? def self.quoted_eibhear_table_name
      @@adapter.quote(eibhear_table_name)
    end

    # Create model for the translation table
    class {{class_name}} < Granite::Base

      # Create adapter in translation table
      {% if EIBHEAR_SETTINGS[:adapter] %}
        class_getter adapter : Granite::Adapter::Base = Granite::Adapters.registered_adapters.find { |a| a.name === {{EIBHEAR_SETTINGS[:adapter].stringify}} } || raise "No registered adapter with the name '{{EIBHEAR_SETTINGS[:adapter].id}}'"
      {% else %} # Not set by user, copy from parent
        class_getter adapter : Granite::Adapter::Base = {{@type.name}}.adapter
      {% end %}

      field locale_id : String
      field {{@type.name.underscore}}_id : Int64

      {% for name, options in I18N_FIELDS %}
        field {{name}} : String, {{options.double_splat}}
      {% end %}
    end
  end
end
