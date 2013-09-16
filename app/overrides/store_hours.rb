Deface::Override.new(:virtual_path => "spree/shared/_nav_bar",
                     :name => "store_hours_in_header",
                     :insert_after => "nav#top-nav-bar ul#nav-bar",
                     :partial => "spree/store_hours/store_hours",
                     :disabled => false)
