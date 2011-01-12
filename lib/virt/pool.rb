module Virt
# implements Libvirt pool, at the moment it is assumed to be a file based pool.
  class Pool
    include Virt::Util
    attr_reader :name
    def initialize options = {}
      @name = options[:name] || raise("Must Provide a pool name")
      @connection = Virt.connection
      fetch_pool
    end

    alias :to_s :name

    def save
      raise "not implemented"
    end

    def new?
      @pool.nil?
    end

    def volumes
      @pool.list_volumes
    end

    %w{name key path}.each do |method|
      define_method "find_volume_by_#{method}" do |value|
        begin
          @pool.send("lookup_volume_by_#{method}", value)
        rescue Libvirt::RetrieveError
        end
      end
    end

    def path
      document "pool/target/path"
    end

    def create_vol vol
      raise "Must provide a Virt::Volume object" unless vol.is_a?(Virt::Volume)
      raise "Pool not saved, cant create volume" if new?
      @pool.create_vol_xml vol.xml
    end

    private

    def fetch_pool
      if @pool = @connection.connection.lookup_storage_pool_by_name(name)
        @xml_desc = @pool.xml_desc
      end
    end
  end
end
