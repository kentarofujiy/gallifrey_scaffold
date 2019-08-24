# encoding : utf-8
class GallifreyJointableGenerator < Rails::Generators::Base
  require_relative 'gallifrey_scaffold_common_methods'
  include GallifreyScaffoldCommonMethods

  source_root File.expand_path('../templates', __FILE__)

  argument :join_models, :type => :array, :default => [], :banner => "model model"
  
  def create_htm_model
    if join_models.length != 2 then
      say_status("Error", "Error need two singular models : example : user product", :red)
    else
      sorted_model = join_models.sort

      # Generate migration
    # migration_content = "
     # create_table :#{sorted_model[0].pluralize}_#{sorted_model[1].pluralize}, :id => false do |t|
    #    t.integer :#{sorted_model[0]}_id
     #   t.integer :#{sorted_model[1]}_id
    #  end

     # add_index :#{sorted_model[0].pluralize}_#{sorted_model[1].pluralize}, [:#{sorted_model[0]}_id, :#{sorted_model[1]}_id]
      #"
      model_command = "
      #{sorted_model[0].capitalize}#{sorted_model[1].capitalize}
      "
      model_options ="
      #{sorted_model[0]}_id:integer #{sorted_model[1]}_id:integer
      "
      model_content = "
        belongs_to #{sorted_model[0]}
        belongs_to #{sorted_model[1]}
      "
    rmodel0 = "@#{sorted_model[0]}.#{sorted_model[1].pluralize}"
    rmodel1 = "@#{sorted_model[1]}.#{sorted_model[0].pluralize}"
      #migration_name = "create_join_table_for_#{sorted_model[0]}_and_#{sorted_model[1]}"
      generate("model", "#{sorted_model[0]}_#{sorted_model[1]} #{sorted_model[0]}_id:integer #{sorted_model[1]}_id:integer")

     # filename = Dir.glob("db/migrate/*#{migration_name}.rb")[0]

      #inject_into_file(filename, migration_content, :after => "def change")

      # Add habtm relation
      inject_into_file("app/models/#{sorted_model[0]}_#{sorted_model[1]}.rb", "\n  belongs_to :#{sorted_model[0]} \n belongs_to :#{sorted_model[1]}", :after => "< ApplicationRecord")
      
      inject_into_file("app/models/#{sorted_model[0]}.rb", "\n has_many :#{sorted_model[0]}_#{sorted_model[1].pluralize} \n has_many :#{sorted_model[1].pluralize}, through: :#{sorted_model[0]}_#{sorted_model[1].pluralize}", :after => "< ApplicationRecord")
      
        inject_into_file("app/models/#{sorted_model[1]}.rb", "\n has_many :#{sorted_model[0]}_#{sorted_model[1].pluralize} \n has_many :#{sorted_model[0].pluralize}, through: :#{sorted_model[0]}_#{sorted_model[1].pluralize}", :after => "< ApplicationRecord")
        
      inject_into_file("app/controllers/#{sorted_model[0].pluralize}_controller.rb", ",#{sorted_model[1]}_ids:[], ",  :after => "permitted_attributes")
       inject_into_file("app/controllers/#{sorted_model[1].pluralize}_controller.rb", ",#{sorted_model[0]}_ids:[], ",  :after => "permitted_attributes")
       # inject_into_file("app/models/#{sorted_model[1]}.rb", "#{sorted_model[0]}_ids[], ",  :after => "def self.permitted_attributes\n    return ")
        inject_into_file("app/views/#{sorted_model[1].pluralize}/_form.html.erb", "\n  <%= f.collection_check_boxes :#{sorted_model[0]}_ids, #{sorted_model[0].capitalize}.all, :id, @#{sorted_model[1]}.attributes.keys[1].to_sym do |cb| %><% cb.label(class: 'checkbox-inline input_checkbox col-sm-2', style: 'float: none') {cb.check_box(class: 'checkbox') + cb.text} %><% end %>", :after => "<!-- Gallifrey_scaffold - AddField - Do not remove -->")
        
        inject_into_file("app/views/#{sorted_model[0].pluralize}/_form.html.erb", "\n <%= f.collection_check_boxes :#{sorted_model[1]}_ids, #{sorted_model[1].capitalize}.all, :id, @#{sorted_model[0]}.attributes.keys[1].to_sym do |cb| %><% cb.label(class: 'checkbox-inline input_checkbox col-sm-2', style: 'float: none') {cb.check_box(class: 'checkbox') + cb.text} %><% end %>", :after => "<!-- Gallifrey_scaffold - AddField - Do not remove -->")
        # inject_into_file"app/views/#{sorted_model[0].pluralize}/show.html.erb", :after => "<!-- Gallifrey_scaffold - AddField - Field - Do not remove -->" do
        #     <<-RUBY
        #     <%= render_partial("app/views/partials/_hmt_related_show_0.html.erb",  locals: { object: "#{rmodel0}" } %>
        #     RUBY
        # end
        #   inject_into_file"app/views/#{sorted_model[1].pluralize}/show.html.erb", :after => "<!-- Gallifrey_scaffold - AddField - Field - Do not remove -->" do
        #     <<-RUBY
        #     <%= render_partial("app/views/partials/_hmt_related_show_1.html.erb",  locals: { object: "#{rmodel1}" } %>
        #     RUBY
        # end
   
   inject_into_file("app/views/#{sorted_model[0].pluralize}/show.html.erb", "\n  <ul><%=  @#{sorted_model[0]}.#{sorted_model[1].pluralize}.each do |ba| %> 
  <li><%= ba.attributes.keys %>:  <%= ba.attributes.values %></li>
 <ul><% end %>", :after => "<!-- Gallifrey_scaffold - AddField - Field - Do not remove -->")          


  end
end
