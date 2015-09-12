#
# Cookbook Name:: oauth2-proxy
# Spec:: default
#
# Copyright (c) 2015 Tom Robison, All Rights Reserved.
#
require 'spec_helper'

describe 'oauth2-proxy::default' do
  cached(:chef_run) { ChefSpec::SoloRunner.converge described_recipe }

  it 'converges' do
    chef_run
  end
end
