Deface::Override.new(:virtual_path => "spree/shared/_main_nav_bar",
                     :name => "store_hours_in_header",
                     :insert_bottom => "#main-nav-bar",
                     :partial => "spree/store_hours/store_hours",
                     :disabled => false)
