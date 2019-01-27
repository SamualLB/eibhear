macro disable_eibhear_docs?(stmt)
  {% val = env("DISABLE_EIBHEAR_DOCS") %}
  {% unless env("DISABLE_EIBHEAR_DOCS" == "false") %}
    # :nodoc:
    {{stmt.id}}
  {% else %}
    {{stmt.id}}
  {% end %}
end

module Eibhear::Translatable
  include Table
  include Fields
  
  macro included
    macro finished
      __process_i18n_table
      __process_i18n_fields
    end
  end

end
