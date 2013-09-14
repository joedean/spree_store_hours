Deface::Override.new(:virtual_path => "spree/layouts/admin",
                     :name => "store_hours_admin_tab",
                     :insert_bottom => "[data-hook='admin_tabs']",
                     :text => "<%= tab(:store_hours, :icon => 'icon-file') %>")
