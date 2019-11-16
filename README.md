# Gallifrey is work in progress largely based on [Beautiful Scaffold](https://github.com/rivsc/Beautiful-Scaffold) but for rails >5.2 and bootstrap4.

> BE WARNED: it's buggy and only (often) makes sense only to myself. The documentation may not be updated and I am often changing this...

## How to use this:

+ create new rails project with Postgres database:
```bash
rails new <name> -d postgresql
```
+ add Gallifrey to your project:
    in Gemfile:
```ruby
gem 'gallifrey_scaffold', :git => 'https://github.com/kentarofujiy/gallifrey_scaffold.git'
```
+ bundle
```bash
bundle install
```
+ create test and dev dbs
```bash
rake db:create
```
+ run db migrations if any
```bash
rake db:migrate
```
+ you don't want Gallifrey messing with your gems so add the dependencies yourself:
    in Gemfile
```ruby
gem 'will_paginate'
gem 'ransack'
gem 'polyamorous', '1.3.1'
gem 'jquery-ui-rails'
gem 'prawn'
gem 'prawn-table', '0.2.2'
gem 'sanitize'
gem 'chardinjs-rails'
gem 'momentjs-rails', '>= 2.9.0'
gem 'bootstrap3-datetimepicker-rails', '~> 4.17.47'
gem "aws-sdk-s3", require: false
gem 'rack-cors'
gem "mail"
gem 'browser'
gem 'jquery_mask_rails'
gem "responders"
```
+ bundle
```bash
bundle install
```
+ setup Active Storage (I, mean at least do the very basics at this point):
```bash
rails active_storage:install
```
+ start setting up authentication by scaffolding a user model (just ask for a name:string and role:string fields, the other necessary stuff will be added by devise later on)
    rails generate gallifrey_scaffold user name:string role:string --donttouchgem=true
+ run db migrations if any
```bash
rake db:migrate
```
+ setup an user model with devise/cancan auth
```bash
rails g gallifrey_devisecancan user
```
+ run db migrations if any
```bash
rake db:migrate
```
+ tell the controller it's now managed by cancan:
    in controllers/users_controller.rb uncomment:
```ruby
# Uncomment for check abilities with CanCan
authorize_resource
        ```
+ bengin setting up abilities:
    in models:ability.rb
```ruby
can :manage, :all if user.role == "admin"
can [:index, :show, :edit], :all if user.role == "moderator"
```
+ if you want a dropdown with available roles at user editing form:
    in models>user.rb
```ruby
ROLES = %i[admin moderator author banned] (or whatever list or options you may like)
```
    in views>users>_form.html.erb
```ruby
<%= f.collection_select(:role, User::ROLES, :to_s, lambda{|i| i.to_s.humanize}) %>
```
+ it might be a good idea not to allow other users to set roles to do so:
    controllers>users_controller.rb:
        in update action:
```ruby            
authorize! :assign_roles, @user if params[:user][:assign_roles]
```
    in models>ability.rb
```ruby
can :assign_roles, User if user.role == "admin"
```
    now you can make sure the form field isn't visible:
        views/users/_form.html.erb
```ruby           
<% if can? :assign_roles, @user %>
    <div class="form-group">
            <%= f.label :role, t('app.models.user.bs_attributes.role', :default => 'role').capitalize, :class => "control-label"        <%= f.collection_select(:role, User::ROLES, :to_s, lambda{|i| i.to_s.humanize}) %>
    </div>
<% end %>
```
+ create a first model for testing, let's call it sandbox
+ run db migrations:
```bash
rails generate gallifrey_scaffold sandbox title:text body:wysiwyg  color:color --donttouchgem=true
```
+ migrate your db:
```bash
rake db:migrate
```
+ add locale gems:
    in Gemfile
```
gem 'rails-i18n', '~> 5.1'
```
+ bundle:
```bash
bundle install
```
+ add pt .yml files to config>locales folder:
+ set default locale in config>application.rb:
```ruby
config.i18n.default_locale = :pt
I18n.available_locales = [:pt]
```
+ get Gallifrey to generate translation for your model:
```bash
rails g gallifrey_locale all
```
    > É necessário criar os locales a cada model adicionado e modificar o arquivo em config/locales/<projeto>.yml

= Gallifrey Scaffold

Gallifrey Scaffold is a gem which propose generators for a complete scaffold with paginate, sort and filter.
Fully customizable.


== Install


=== RubyOnRails 5+

Add this in your Gemfile :

      gem 'gallifrey_scaffold', :git => 'https://github.com/kentarofujiy/gallifrey_scaffold.git'

=== Next

And run

    bundle install

== Usage

=== Scaffold

    rails generate gallifrey_scaffold model attr:type attr:type... [--namespace=name] [--donttouchgem=name]

Types available:
* integer
* float
* text
* string
* price
* color
* wysiwyg

# Example : products

    rails g gallifrey_scaffold product name:string price:price tva:float description:wysiwyg visible:boolean && rake db:migrate

# Example : admin products

    rails g gallifrey_scaffold product name:string price:price tva:float description:wysiwyg overview_description:wysiwyg visible:boolean --namespace=admin && rake db:migrate

=== Migration (Use Add[Field]To[ModelPluralize] syntax)

    rails g gallifrey_migration AddFieldToModels field:type

=== Locale (i18n) (Example)

Run `rake db:migrate` before `rails g gallifrey_locale` (to get lastest attribute translation)

    rails g gallifrey_locale all
    rails g gallifrey_locale en
    rails g gallifrey_locale fr
    rails g gallifrey_locale de
    rails g gallifrey_locale pt

=== Join Table (has_and_belongs_to_many relation)

    rails g gallifrey_jointable model1 model2

=== Install et Configure Devise (authentification) and Cancan (authorization)

    rails g gallifrey_devisecancan model

=== In views

==== Barcodes

Set code like this :

    <span class="barcode" data-barcode="1234567890128" data-type-barcode="ean13"></span>

data-type-barcode can be :

    codabar
    code11 (code 11)
    code39 (code 39)
    code93 (code 93)
    code128 (code 128)
    ean8 (ean 8)
    ean13 (ean 13)
    std25 (standard 2 of 5 - industrial 2 of 5)
    int25 (interleaved 2 of 5)
    msi
    datamatrix (ASCII + extended)

==== Chardinjs (overlay instructions)

Example : This button triggers chardinjs on element with 'menu' id.

    <a href="#" class="bs-chardinjs" data-selector="#menu">Help Menu</a>

If you want display all chardinjs :

    <a href="#" class="bs-chardinjs" data-selector="body">Help</a>

Just add `class="bs-chardinjs"` in a button / link for trigger chardinjs. Gallifrey-Scaffold does the job !

For add instruction to element, read official documentation : https://github.com/heelhook/chardin.js#adding-data-for-the-instructions
