module Mongoid
  module Document
    module Taggable
      def self.included(base)
        base.class_eval do |klass|
          klass.field :tags, :type => Array    
          klass.index :tags      
          
          klass.send :after_save, :rebuild_tags
        
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
        
        protected
          def rebuild_tags
            self.collection.map_reduce(
              "function() { if(this.tags) this.tags.forEach(function(t){ emit(t, 1); }); }",
              "function(key,values) { var count = 0; values.forEach(function(v){ count += v; }); return count; }",
              { :out => 'tags' }
            )
          end
      end
 
      module ClassMethods
        
        def all_tags(opts={})
          tags = Mongoid.master.collection('tags')
          opts.merge(:sort => ["_id", :desc]) unless opts[:sort]
          tags.find({}, opts).to_a.map!{|item| { :name => item['_id'], :count => item['value'].to_i } }
        end
        
        def tagged_with(tags)
          tags = [tags] unless tags.is_a? Array
          criteria.in(:tags => tags).to_a
        end
      end
      
    end
  end
end
