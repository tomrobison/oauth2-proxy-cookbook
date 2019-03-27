# Cookbook Name:: oauth2-proxy
# Resource/Provider:: install
# Author:: Tom Robison
# License:: Apache 2.0
#
# Copyright 2015, Tom Robison

require 'poise'

class Chef
  class Resource
    class Oauth2ProxyInstall < Resource
      include Poise

      provides(:oauth2_proxy_install)

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
    end
  end

  class Provider
    class Oauth2ProxyInstall < Provider
      include Poise
      include Chef::DSL::Recipe

      def action_create
        converge_by("create resource #{new_resource.name}_oauth2_proxy") do
          notifying_block do
            proxy = proxy_properties

            log "Installing #{proxy[:name]}_oauth2_proxy"

            directory proxy[:install_dir] do
              recursive true
              owner proxy[:user]
              group proxy[:group]
              mode '0755'
            end

            library_version = "#{proxy[:library]}-#{proxy[:version]}"
            proxy_distribution = "#{proxy[:os]}-#{proxy[:kernel_machine]}.go#{proxy[:go_version]}"
            temp_file = "#{library_version}.#{proxy_distribution}.tar.gz"
            proxy_binary = "#{proxy[:install_dir]}/#{library_version}.#{proxy_distribution}/#{proxy[:library]}"

            file_url_basepath = "https://github.com/bitly/oauth2_proxy/releases/download/v#{proxy[:version]}"
            file_checksum = 'c6d8f6d74e1958ce1688f3cf7d60648b9d0d6d4344d74c740c515a00b4e023ad'
            temp_path = Chef::Config[:file_cache_path]

            remote_file "#{temp_path}/#{temp_file}" do
              checksum file_checksum
              source "#{file_url_basepath}/#{temp_file}"
              action [:create]
            end

            @run_context.include_recipe 'libarchive::default'
            libarchive_file temp_file do
              path "#{temp_path}/#{temp_file}"
              extract_to proxy[:install_dir]
              owner proxy[:user]
              action [:extract]
              not_if { ::File.exist?(proxy_binary) }
            end
          end
        end
      end
    end

    private

    def proxy_properties
      {
        name: new_resource.name,
        user: new_resource.user,
        group: new_resource.group,
        install_dir: new_resource.install_dir,
        library: new_resource.library,
        version: new_resource.version,
        os: new_resource.os,
        kernel_machine: new_resource.kernel_machine,
        go_version: new_resource.go_version
      }
    end
  end
end
