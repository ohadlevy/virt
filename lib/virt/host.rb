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
    def storage_pools
      connection.list_storage_pools.map {|p| create_pool({:name => p})}
    end

    # Returns a Virt::Pool object based on the pool name
    def storage_pool pool
      create_pool({:name => pool.is_a?(Libvirt::StoragePool) ? pool.name : pool })
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
        return create_guest({:name => name})
      end
    end

    def find_guest_by_id id
      Array(id).map do |did|
        return create_guest({:name => connection.lookup_domain_by_id(did).name})
      end
    end

    protected

    def create_guest opts
      Virt::Guest.new opts
    end

    def create_pool opts
      Virt::Pool.new opts
    end

  end
end
