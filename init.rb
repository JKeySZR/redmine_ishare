# frozen_string_literal: true

# This file is a part of redmine_ishare,
# a issue sharing plugin for Redmine.
#
# Copyright (c) 2022 Bocharov.pw
# https://bocharov.pw

require 'redmine'

Redmine::Plugin.register :redmine_ishare do
  name 'Redmine Ishare plugin'
  author 'Bocharov Mikhail Sergeevich'
  description 'Allows to create access, for issues by password, for anonymous user'
  version '0.0.1'
  url 'http://bocharov.pw/projects/redmine/plugin/ishare'
  author_url 'https://bocharov.pw/about'

  # @todo need load lightbox for issue template
  # begin
  #   requires_redmine_plugin :redmine_lightbox2, :version_or_higher => '0.5.1'
  # rescue
  #   Redmine::PluginNotFound
  #   raise 'Please install LightBox2 plugin (https://github.com/...)'
  # end

  # settings default: loader.default_settings,
  #          partial: 'redmine_ishare/settings/settings'

  project_module :ishare do

    permission :ishare_share, {
      :ishare => [:create, :new]
    }

  end

  menu :admin_menu,
       :ishare,
       { controller: 'settings', action: 'plugin', id: 'redmine_ishare' },
       caption: :ishare_label_module,
       :html => { :class => 'icon icon-view_customize' },
       :if => Proc.new { User.current.admin? }

end
# lib/redmine_ishare.rb
# require File.dirname(__FILE__) +
require 'redmine_ishare'
