

module RedmineIshare
  module Patches
    module ApplicationControllerPatch
      def self.included(base)
        base.send(:include, InstanceMethods)

        base.class_eval do
          unloadable # Send unloadable so it will not be unloaded in development
          alias_method :check_if_login_required, :check_if_login_required_ishare
          before_action :ishare_redirects
          helper IshareHelper
        end
      end

      module InstanceMethods

        def check_if_login_required_ishare
          dbg =0
          # @todo тут херня надо переделать.
          # Это хак для того чтобы обойти , принудительный редирект на страницу ввода логина и пароля
          if !params['controller'].nil? && params['controller'] == 'ishare'
            if !params['action'].nil? && params['action'] == 'new'
              require_login if !User.current.logged?;
            end
            # session[:ishare][issue_id]
            #session[:ishare]={'container_id' => issue_id.to_i}
            return true
          end

          # Attachments -  Первым сработает эта проверка, и если  она пройдена
          # запустится проверка read_authorize_ishare в AttachmentsControllerPatch
          if !params['controller'].nil? && params['controller'] == 'attachments'
            return true if session[:ishare].nil?
            # Найти в какие заадчи используется данный аттатчмет и если он есть
            # в сесси и пароль введен -тогда разрешить
            attach_id = params['id']
            attach = Attachment.find(attach_id)
            issue_id = attach.container_id.to_s
            return true if issue_id.nil?

            if session[:ishare].key?(issue_id)
              return false if !session[:ishare][issue_id]['passed'].nil?
            end

          end


           # Original code
           return true if User.current.logged?
           require_login if Setting.login_required?
        end

        def ishare_redirects
          dbg = 0
          #user = User.find(5)
          #User.current = user
          #start_user_session(user)

          #sign_in @user, :bypass => true
          #IshareController.showissue2

          # if request.get? && RedmineCms.redirects[request.path]
          #   query_params = URI.encode_www_form(request.query_parameters)
          #   query_params = (RedmineCms.redirects[request.path] =~ /\?/ ? '&' : '?') + query_params if query_params.present?
          #   redirect_to RedmineCms.redirects[request.path] + query_params, :status => 301
          # end
        end


      end
    end
  end
end

unless ApplicationController.included_modules.include?(RedmineIshare::Patches::ApplicationControllerPatch)
  ApplicationController.send(:include, RedmineIshare::Patches::ApplicationControllerPatch)
end
