#
# Cookbook Name:: oauth2-proxy
# Spec:: example
#
# Copyright (c) 2015 Tom Robison, All Rights Reserved.
#
require 'spec_helper'

describe 'oauth2-proxy::example' do
  cached(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.set['oauth2-proxy']['google'] = {}
    end.converge(described_recipe)
  end

  it 'converges' do
    chef_run
  end
end
