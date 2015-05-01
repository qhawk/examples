#
# Cookbook Name:: php_on_apache
# Spec:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

require 'spec_helper'

describe 'php_on_apache::default' do
  context 'When all attributes are default, on an unspecified platform' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      chef_run # This should not raise an error
    end

    it 'updates the package repository' do
      expect(chef_run).to run_execute('apt-get update')
    end

    it 'installs the apache packages' do
      expect(chef_run).to install_package('apache2')
    end

    it 'installs the php packages' do
      expect(chef_run).to install_package('php5')
      expect(chef_run).to install_package('libapache2-mod-php5')
      expect(chef_run).to install_package('php5-mcrypt')
    end

    it 'creates a file to enable index.php files' do
      expect(chef_run).to create_template('/etc/apache2/mods-enabled/dir.conf')
    end

    it 'creates an index page' do
      expect(chef_run).to create_cookbook_file('/var/www/index.php')
    end

    it 'starts and enables the apache2 service' do
      expect(chef_run).to start_service('apache2')
      expect(chef_run).to enable_service('apache2')
    end
  end
end
