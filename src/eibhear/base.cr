module Eibhear::Base
  macro included
    EIBHEAR_FIELDS = [] of Nil
    EIBHEAR_TABLE = {name: translations, klass: nil}
  end

  macro has_translations(table, *fields)
    {% EIBHEAR_TABLE[:name] = table.id %}
    {% if table.is_a? TypeDeclaration %}
      {% EIBHEAR_TABLE[:klass] = table.type %}
    {% end %}
    {% for field in fields %}
      {% EIBHEAR_FIELDS << {name: field.id, type: String, raise_on_nil: false} %}
      {% if EIBHEAR_FIELDS.last[:name].ends_with? '!' %}
        {% EIBHEAR_FIELDS.last[:raise_on_nil] = true %}
        {% EIBHEAR_FIELDS.last[:name] = EIBHEAR_FIELDS.last[:name][0...-1] %}
      {% end %}
      {% if field.is_a? TypeDeclaration %}
        {% EIBHEAR_FIELDS.last[:type] = field.type %}
      {% end %}
      {{puts EIBHEAR_FIELDS.last}}
    {% end %}
  end
end
