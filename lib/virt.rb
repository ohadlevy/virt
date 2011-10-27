require 'virt/util'
require 'virt/connection'
require 'virt/host'
require 'virt/guest'
require 'virt/pool'
require 'virt/volume'
require 'virt/interface'
module Virt

  autoload :KVM,    "virt/kvm"
  autoload :VMWare, "virt/vmware"
  class << self

    def connect uri, options = {}
      @connection = Virt::Connection.new uri, options
    end

    def connection
      return @connection if @connection and !@connection.closed?
      raise "No Connection or connection has been closed"
    end

  end

end
