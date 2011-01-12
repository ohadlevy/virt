require 'libvirt'
module Virt
  class Connection
    attr_reader :connection

    def initialize uri
      raise("Must provide a guest to connect to") unless uri
      @connection = Libvirt::open uri
    end

    def closed?
      connection.closed?
    end

    def secure?
      connection.encrypted?
    end

    def version
      connection.libversion
    end

    def disconnect
      connection.close
    end

    def host
      Host.new
    end

  end
end
