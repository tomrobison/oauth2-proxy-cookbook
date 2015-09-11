#
# Cookbook Name:: oauth2-proxy
# Spec:: default
#
# Copyright (c) 2015 Tom Robison, All Rights Reserved.

require 'spec_helper'

describe 'oauth2-proxy::default' do

  context 'When all attributes are default, on an unspecified platform' do

    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      chef_run # This should not raise an error
    end

  end
end
