(import /format)

(def Person @{:fmt (fn [{:first first :middle middle :last last :age age :sex sex} spec]
                     (format/compile "{middle:.1}. {last}, {first} [{age}{0:c}]" ((string/ascii-upper sex) 0)))})

(defn person/new [first middle last age sex]
  (table/setproto @{:first first :middle middle :last last :age age :sex sex} Person))

(format/fprint "{}" (person/new "Ian" "Reed" "Shehadeh" 20 :male))
