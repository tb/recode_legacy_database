# RecodeLegacyDatabase
module Recode #:nodoc:
  module Legacy #:nodoc:
    module Database #:nodoc:
      
      def self.included(base) #:nodoc:
        base.extend ClassMethods
      end

      module ClassMethods
        # recode_legacy_database :from => "ISO-8859-1", :to => "UTF-8"
        def recode_legacy_database(*args)
          options = { :from => "ISO-8859-1", :to => "UTF-8" }
          options.merge!( args.last.is_a?( Hash ) ? args.last : {} )
          
          class_inheritable_accessor :options
          self.options = options
          
          self.send(:include, Recode::Legacy::Database::InstanceMethods)
        end
      end
      
      # This module contains instance methods
      module InstanceMethods
        require 'iconv'
        
        def recode(from, to)
          attributes.each do |k,v|
            if v.class.to_s == "String" and !v.empty?
              self[k] = Iconv.conv(to, from, v) rescue v
            end
          end
        end
        
        def after_initialize
          recode(self.options[:from], self.options[:to])
        end

        def before_save
          recode(self.options[:to], self.options[:from])
        end

      end
    end
  end
end
