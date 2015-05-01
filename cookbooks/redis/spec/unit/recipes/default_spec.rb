#
# Cookbook Name:: redis
# Spec:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

require 'spec_helper'

describe 'redis::default' do
  context 'When all attributes are default, on an unspecified platform' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      chef_run # This should not raise an error
    end

    it 'updates the package repository' do
      expect(chef_run).to run_execute("apt-get update")
    end

    it 'installs essential packages' do
      expect(chef_run).to install_package('build-essential')
      expect(chef_run).to install_package('tcl8.5')
    end

    it 'retrieves a stable version of redis' do
      expect(chef_run).to create_remote_file('/root/redis-2.8.9.tar.gz').with(
        :source => 'http://download.redis.io/releases/redis-2.8.9.tar.gz')
    end

    it 'extracts the source' do
      expect(chef_run).to run_execute('tar xzf redis-2.8.9.tar.gz').with(
        :cwd => '/root')
    end

    it 'makes and installs the software' do
      expect(chef_run).to run_execute('make && make install').with(
        :cwd => '/root/redis-2.8.9')
    end

    it 'installs the service without user interaction' do
      expect(chef_run).to run_execute('echo -n | ./install_server.sh').with(
        :cwd => '/root/redis-2.8.9/utils')
    end

    it 'starts the service on the default port' do
      expect(chef_run).to start_service('redis_6379')
    end

  end
end
