# Cookbook Name:: oauth2-proxy
# Resource/Provider:: configure
# Author:: Tom Robison
# License:: Apache 2.0
#
# Copyright 2015, Tom Robison

require 'poise'

class Chef
  class Resource
    class Oauth2ProxyConfigure < Resource
      include Poise

      provides(:oauth2_proxy_configure)

      actions(:create)

      attribute(:name, kind_of: String, name_attribute: true)
      attribute(:user, kind_of: String, default: 'oauth2_proxy')
      attribute(:group, kind_of: String, default: 'oauth2_proxy')
      attribute(:install_dir, kind_of: String, default: '/opt/oauth2_proxy')
      attribute(:parameters, kind_of: Hash, default: {})
      attribute(:source, kind_of: String, default: 'basic.conf.erb')
      attribute(:source_cookbook, kind_of: String, default: 'oauth2-proxy')
    end
  end

  class Provider
    class Oauth2ProxyConfigure < Provider
      include Poise
      include Chef::DSL::Recipe

      def action_create
        converge_by("configure resource #{new_resource.name}_oauth2_proxy") do
          notifying_block do
            proxy = configure_properties

            log "Configuring #{proxy[:name]}_oauth2_proxy"

            directory proxy[:install_dir] do
              recursive true
              owner proxy[:user]
              group proxy[:group]
              mode '0755'
            end

            template "#{proxy[:install_dir]}/#{proxy[:name]}.conf" do
              source proxy[:source]
              cookbook proxy[:source_cookbook]
              owner proxy[:user]
              group proxy[:group]
              mode '0755'
              variables(
                oauth2_proxy: proxy[:parameters]
              )
            end
          end
        end
      end
    end

    private

    def configure_properties
      {
        name: new_resource.name,
        user: new_resource.user,
        group: new_resource.group,
        install_dir: new_resource.install_dir,
        parameters: new_resource.parameters,
        source: new_resource.source,
        source_cookbook: new_resource.source_cookbook
      }
    end
  end
end
