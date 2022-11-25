# frozen_string_literal: true

# This file is a part of redmine_ishare,
# a issue sharing plugin for Redmine.
#
# Copyright (c) 2022 Bocharov.pw
# https://bocharov.pw

module RedmineIshare
  module Patches
    module AttachmentsControllerPatch
      def self.included(base)
        base.send(:include, InstanceMethods)

        base.class_eval do
          unloadable
          alias_method :read_authorize, :read_authorize_ishare
        end
      end

      module InstanceMethods

        def read_authorize_ishare
          issue_id = @attachment.attributes['container_id'].to_s
          if !session[:ishare].nil? && !issue_id.nil?
            # @attachment.attributes['container_id']
            return true if  !session[:ishare][issue_id]['passed'].nil?
          end
          # Оригиналтный код из AttachmentsController.read_authorize
          @attachment.visible? ? true : deny_access
        end

      end
    end
  end
end

unless AttachmentsController.included_modules.include?(RedmineIshare::Patches::AttachmentsControllerPatch)
  AttachmentsController.send(:include, RedmineIshare::Patches::AttachmentsControllerPatch)
end
