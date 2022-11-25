
require 'redmine_ishare/patches/application_controller_patch'
require 'redmine_ishare/patches/attachments_controller_patch'

require_dependency 'redmine_ishare/hooks/ishare_hooks'

module RedmineIshare

  class IshareSetup
    def initialize(app)
      @app = app
    end

    def call(env)
      @request = Rack::Request.new(env)
      Multitenant.current_tenant = Tenant.find_by_subdomain!(get_subdomain)
      @app.call(env)
    end

    private

    def get_subdomain
      host = @request.host
      return nil unless !(host.nil? || /\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$/.match(host))
      subdomain = host.split('.')[0..-3].first
      return subdomain unless subdomain == "www"
      return host.split('.')[0..-3][1]
    end
  end

end