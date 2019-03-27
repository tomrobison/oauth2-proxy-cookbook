# Cookbook Name:: oauth2-proxy
# Resource/Provider:: configure
# Author:: Tom Robison
# License:: Apache 2.0
#
# Copyright 2015, Tom Robison

require 'poise'

class Chef
  class Resource
    class Oauth2ProxyService < Resource
      include Poise

      provides(:oauth2_proxy_configure)

      actions(:create)

      attribute(:name, kind_of: String, name_attribute: true)
      attribute(:user, kind_of: String, default: 'oauth2_proxy')
      attribute(:group, kind_of: String, default: 'oauth2_proxy')
      attribute(:install_dir, kind_of: String, default: '/opt/oauth2_proxy')
      attribute(:library, kind_of: String, default: 'oauth2_proxy')
      attribute(:version, kind_of: String, default: '2.0.1')
      attribute(:os, kind_of: String, default: 'linux')
      attribute(:kernel_machine, kind_of: String, default: 'amd64')
      attribute(:go_version, kind_of: String, default: '1.4.2')
      attribute(:template_cookbook, kind_of: String, default: 'oauth2-proxy')
      attribute(:run_template, kind_of: String, default: 'oauth2_proxy')
      attribute(:log_template, kind_of: String, default: 'oauth2_proxy')
    end
  end

  class Provider
    class Oauth2ProxyService < Provider
      include Poise
      include Chef::DSL::Recipe

      def action_create
        converge_by("configure service for #{new_resource.name}_oauth2_proxy") do
          notifying_block do
            proxy = service_properties

            log "Add service #{proxy[:name]}_oauth2_proxy"

            @run_context.include_recipe 'runit::default'

            library_version = "#{proxy[:library]}-#{proxy[:version]}"
            proxy_distribution = "#{proxy[:os]}-#{proxy[:kernel_machine]}.go#{proxy[:go_version]}"

            proxy_binary = "#{proxy[:install_dir]}/#{library_version}.#{proxy_distribution}/#{proxy[:library]}"

            proxy_command = "#{proxy_binary} -config=#{proxy[:install_dir]}/#{proxy[:name]}.conf"

            runit_service "#{proxy[:name]}_oauth2_proxy" do
              owner proxy[:user]
              group proxy[:group]

              cookbook proxy[:template_cookbook]
              run_template_name proxy[:run_template]
              log_template_name proxy[:log_template]

              options(
                user: proxy[:user],
                command: proxy_command
              )
            end
          end
        end
      end
    end

    private

    def service_properties
      {
        name: new_resource.name,
        user: new_resource.user,
        group: new_resource.group,
        install_dir: new_resource.install_dir,
        library: new_resource.library,
        version: new_resource.version,
        os: new_resource.os,
        kernel_machine: new_resource.kernel_machine,
        go_version: new_resource.go_version,
        template_cookbook: new_resource.template_cookbook,
        run_template: new_resource.run_template,
        log_template: new_resource.log_template
      }
    end
  end
end
