macro disable_eibhear_docs?(stmt)
  {% val = env("DISABLE_EIBHEAR_DOCS") %}
  {% unless env("DISABLE_EIBHEAR_DOCS" == "false") %}
    # :nodoc:
    {{stmt.id}}
  {% else %}
    {{stmt.id}}
  {% end %}
end

module Eibhear::OldTranslatable
  #include Table
  #include Fields
  
  #macro included
  #  macro finished
  #    __process_eibhear_table
  #    __process_eibhear_fields
  #  end
  #end

end
