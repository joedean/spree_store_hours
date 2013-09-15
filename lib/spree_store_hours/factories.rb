FactoryGirl.define do
  # Define your Spree extensions Factories within this file to enable applications, and other extensions to use and override them.
  #
  # Example adding this to your spec_helper will load these Factories for use:
  # require 'spree_store_hours/factories'
  factory :spree_store_hour, :class => Spree::StoreHour do
    wday 1
    open_time '8:00 am'
    close_time '5:00 pm'
  end
end
