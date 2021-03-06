#
# Cookbook Name:: oauth2-proxy
# Recipe:: example
#
# Copyright (c) 2015 Tom Robison, All Rights Reserved.

oauth2_proxy_user 'oauth2_proxy'

oauth2_proxy_install 'google'

oauth2_proxy_configure 'google' do
  parameters node['oauth2-proxy']['google']
end

oauth2_proxy_service 'google'
