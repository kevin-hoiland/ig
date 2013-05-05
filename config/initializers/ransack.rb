Ransack.configure do |config|
  config.add_predicate 's', # Name your predicate
                       # What non-compound ARel predicate will it use? (eq, matches, etc)
                       :arel_predicate => 'matches',
                       # Format incoming values as you see fit. (Default: Don't do formatting)
                       :formatter => proc {|v| "%"+v.gsub(" ", "%")+"%"},
                       # Validate a value. An "invalid" value won't be used in a search.
                       # Below is default.
                       :validator => proc {|v| v.present?},
                       # Should compounds be created? Will use the compound (any/all) version
                       # of the arel_predicate to create a corresponding any/all version of
                       # your predicate. (Default: true)
                       :compounds => true,
                       # Force a specific column type for type-casting of supplied values.
                       # (Default: use type from DB column)
                       :type => :string
end

# Patch for ransack (https://github.com/ernie/ransack) to use scopes
# Helps migrating from Searchlogic or MetaSearch
# Place this file into config/initializer/ransack.rb of your Rails 3.2 project
#
# Usage:
#   class Debt < ActiveRecord::Base
#     scope_ransackable :overdue
#     scope :overdue, lambda { where(["status = 'open' AND due_date < ?", Date.today]) }
#   end
#
#   Ransack out of the box ignores scopes. Example:
#     Debt.search(:overdue => true, :amount_gteq => 10).result.to_sql
#      => "SELECT `debts`.* FROM `debts` AND (`debts`.`amount` >= 10.0)"
#
#   This is changed by the patch. Example:
#     Debt.search(:overdue => true).result.to_sql
#     => "SELECT `debts`.* FROM `debts`  WHERE `debts`.`status` = 'open' AND (due_date < '2012-11-23') AND (`debts`.`amount` >= 10.0)"
#
#   Only scopes that return ActiveRecord::Relation are supported.
#   Any other scope or method that is called via Ransack will throw an exception
#   and cause a database transaction rollback.
#
=begin
module Ransack
  class ScopeNotWhitelistedError < Exception; end
 
  module Adapters
    module ActiveRecord
      module Base
        def scope_ransackable(*args)
          @ransackable_scopes ||= []
          @ransackable_scopes  += args.map(&:to_sym).reject { |scope| scope == :scope_ransackable }
        end
 
        def scope_is_ransackable?(scope)
          @ransackable_scopes ||= []
          @ransackable_scopes.include? scope.to_sym
        end
 
 
        def search_with_scopes(params = {}, options = {})
          ransack_scope = self
          ransack_params = {}
 
          # Extract params which refer to a scope
          transaction do
            (params||{}).each_pair do |k,v|
              if ransack_scope.respond_to?(k)
                if !scope_is_ransackable? k
                  raise ScopeNotWhitelistedError.new
                elsif (v == true)
                  ransack_scope = ransack_scope.send(k)
                else
                  ransack_scope = ransack_scope.send(k, v)
                end
                raise ArgumentError.new "#{k} is not a scope that returns an ActiveRecord::Relation" unless ransack_scope.is_a? ::ActiveRecord::Relation
              else
                ransack_params.merge!(k => v)
              end
            end
          end
 
          ransack_scope.search_without_scopes(ransack_params, options)
        end
 
        alias_method_chain :search, :scopes
      end
    end
  end
end
=end