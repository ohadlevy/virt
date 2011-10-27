require 'libvirt'
module Virt
  class Connection
    attr_reader :connection, :type

    def initialize uri, options = {}
      raise("Must provide a host to connect to") unless uri
      if uri =~ /^(esx|vpx)/
        raise("Must provide a username and password") unless options[:username] or options[:password]
        @connection = Libvirt::open_auth(uri, [Libvirt::CRED_AUTHNAME, Libvirt::CRED_PASSPHRASE]) do |cred|
          # This may only be required for ESXi connections, not sure.
          @type = "VMWare"
          case cred['type']
          when ::Libvirt::CRED_AUTHNAME
            options[:username]
          when ::Libvirt::CRED_PASSPHRASE
            options[:password]
          end
        end
      else
        @connection = Libvirt::open uri
        @type = "KVM"
      end
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
      case type
      when "KVM"
        KVM::Host.new
      when "VMWare"
        VMWare::Host.new
      else
        raise "Non supported hypervisor"
      end
    end

  end
end
