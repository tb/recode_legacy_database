# Include hook code here
require 'recode_legacy_database'
ActiveRecord::Base.send(:include, Recode::Legacy::Database)
