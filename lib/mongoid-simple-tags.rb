module Mongoid
  module Document
    module Taggable
      def self.included(base)
        base.class_eval do |klass|
          klass.field :tags, :type => Array, :default => []
          klass.index({ tags: 1 }, { background: true })
        
          include InstanceMethods
          extend ClassMethods
          
        end
      end
      
      module InstanceMethods
        def tag_list=(tags)
          self.tags = tags.split(",").collect{ |t| t.strip }.delete_if{ |t| t.blank? }
        end

        def tag_list
          self.tags.join(", ") if tags
        end

        def tags
          super || []
        end
      end
 

      module ClassMethods

        def all_tags(scope = {})
          map = %Q{
            function() {
              if(this.tags){
                this.tags.forEach(function(tag){
                  emit(tag, 1)
                });
              }
            }
          }

          reduce = %Q{
            function(key, values) {
              var tag_count = 0 ;
              values.forEach(function(value) {
                tag_count += value;
              });
              return tag_count;
            }
          }

          tags = self
          tags = tags.where(scope) if scope.present?

          results = tags.map_reduce(map, reduce).out(inline: true)
          results.to_a.map!{ |item| { :name => item['_id'], :count => item['value'].to_i } }
        end

        def scoped_tags(scope = {})
          warn "[DEPRECATION] `scoped_tags` is deprecated.  Please use `all_tags` instead."
          all_tags(scope)
        end
        
        def tagged_with(tags)
          tags = [tags] unless tags.is_a? Array
          criteria.in(:tags => tags).to_a
        end
      end
      
    end
  end
end