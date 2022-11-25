# frozen_string_literal: true

# This file is a part of redmine_ishare,
# a issue sharing plugin for Redmine.
#
# Copyright (c) 2022 Bocharov.pw
# https://bocharov.pw

module RedmineIshare
  class Hooks < Redmine::Hook::ViewListener
    #include IshareHelper <- эта херня не сработала, чтобы хелпер заработал , надо было пропачить контроллнр

    #render_on :view_issues_show_description_bottom, :partial => 'hooks/issue_form'

    # Если включена в админке в настройках моудля опция использовать бюджетную кнопку - тогда подгрузим этот код

    render_on :view_issues_sidebar_issues_bottom, :partial => 'issues/ishare_sidebar_issues'

    # def view_issues_index_bottom(context)
    #     javascript_include_tag( 'vatra_colapse_filter.js', :plugin => :redmine_kdv)
    # end

  end
end