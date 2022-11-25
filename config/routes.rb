# frozen_string_literal: true

# This file is a part of redmine_ishare,
# a issue sharing plugin for Redmine.
#
# Copyright (c) 2022 Bocharov.pw
# https://bocharov.pw

# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

get  'ishare/:id', :to => 'ishare#showissue', :as => :ishare_show
post 'ishare/:id', :to => 'ishare#igi', :as => :ishare_igi

get  'ishare/:id/create', :to => 'ishare#new', :as => :ishare_new
post 'ishare/:id/create', :to => 'ishare#create', :as => :ishare_new_create