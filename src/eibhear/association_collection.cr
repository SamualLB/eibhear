class Eibhear::AssociationCollection(Owner, Target) < Granite::AssociationCollection(Owner, Target)
  def [](locale : String) : Target
    find_by!(locale: locale)
  end

  def []?(locale : String) : Target?
    find_by(locale: locale)
  end
end
