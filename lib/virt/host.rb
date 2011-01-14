module Virt
  class Host < Virt::Connection
    # Represents a Physical host which runs the libvirt daemon

    attr_reader :connection
    def initialize
      @connection = Virt.connection.connection
    end

    def name
      connection.hostname
    end

    def guests
      {:running => running_guests, :defined => defined_guests}
    end

    def running_guests
      connection.list_domains.map do |domain|
        find_guest_by_id(domain)
      end
    end

    def defined_guests
      connection.list_defined_domains.map do |domain|
        find_guest_by_name domain
      end
    end

    # Available libvirt interfaces, excluding lo
    def interfaces
      connection.list_interfaces.delete_if{|i| i == "lo"}.sort
    rescue => e
      raise "This function is not supported by the hypervisor: #{e}"
    end

    def interface iface
      connection.lookup_interface_by_name(iface)
    end

    # libvirt internal networks
    def networks
      connection.list_networks.map do |network|
        connection.lookup_network_by_name(network).bridge_name
      end
    end

    def storage_pools
      connection.list_storage_pools.map {|p| Pool.new({:name => p})}
    end

    # Returns a Virt::Pool object based on the pool name
    def storage_pool pool
      Pool.new({:name => pool.is_a?(Libvirt::StoragePool) ? pool.name : pool })
    rescue Libvirt::RetrieveError
    end

    # Returns a hash of pools and their volumes objects.
    def volumes
      pools = {}
      storage_pools.each do |storage|
        pools[storage.name] = storage.volumes
      end
      pools
    end

    def find_guest_by_name name
      if connection.lookup_domain_by_name name
        return Guest.new({:name => name})
      end
    end

    def find_guest_by_id id
      id.to_a.map do |did|
        return Guest.new({:name => connection.lookup_domain_by_id(did).name})
      end
    end

  end
end
