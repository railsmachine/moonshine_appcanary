# **Moonshine::AppCanary** is a Moonshine plugin for installing and configuring
# a server to check into [appCanary](https://appcanary.com/).

#### Prerequisites

# * An [appCanary](https://appcanary.com/) account
# * The api key for your appCanary account.
#
module Moonshine
  module AppCanary

    #### Recipe
    #
    # We define the `:appcanary` recipe which can take inline options.
    #
    def appcanary(options = {})
      api_key = options[:api_key] || configuration[:appcanary][:api_key]
      options[:files] ||= configuration[:appcanary][:files] ||= []

      # The only required option is :api_key. We won't fail the deploy over it though, so just return instead.
      unless api_key
        puts "To use the appCanary agent, specify your API key in config/moonshine.yml:"
        puts ":appcanary:"
        puts "  :api_key: YOUR-APPCANARY-API-KEY"
        return
      end

      package 'apt-transport-https',
        :ensure => :installed

      exec 'add appCanary apt key',
        :command => 'wget -q -O - https://packagecloud.io/gpg.key | sudo apt-key add -',
        :unless => "sudo apt-key list | grep 'packagecloud ops (production key) <ops@packagecloud.io>'"

      repo_path = "deb https://packagecloud.io/appcanary/agent/ubuntu/ #{Facter.value(:lsbdistcodename)} main"

      file '/etc/apt/sources.list.d/appcanary.list',
        :content => repo_path,
        :require => [exec('add appCanary apt key'), package('apt-transport-https')]

      exec 'appCanary apt-get update',
        :command => 'sudo apt-get update',
        :refreshonly => true,
        :subscribe => file('/etc/apt/sources.list.d/appcanary.list')

      package 'appcanary',
        :ensure => :installed,
        :require => [file('/etc/apt/sources.list.d/appcanary.list'), exec('appCanary apt-get update')]

      file '/etc/appcanary/agent.conf',
        :content => template(File.join(File.dirname(__FILE__), '..', '..', 'templates', 'agent.conf.erb'), binding),
        :notify => service('appcanary'),
        :require => package('appcanary')

      service 'appcanary',
        :ensure => :running,
        :enable => true,
        :require => [package('appcanary'), file('/etc/appcanary/agent.conf')]
    end
  end
end
