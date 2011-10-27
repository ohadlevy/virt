module Virt
  class Volume
    include Virt::Util
    attr_reader :name, :pool, :type, :allocated_size, :size, :template_path, :key

    def initialize options = {}
      @connection     = Virt.connection
      self.name       = options[:name]           || raise("Volume requires a name")
      @type           = options[:type]           || default_type
      @allocated_size = options[:allocated_size] || default_allocated_size
      @template_path  = options[:template_path]  || default_template_path
      @size           = options[:size]           || default_size
      @pool           = options[:pool].nil? ? @connection.host.storage_pools.first : @connection.host.storage_pool(options[:pool])
      fetch_volume
    end

    def new?
      @vol.nil?
    end

    def save
      raise "volume already exists, can't save" unless new?
      #validations
      #update?
      @vol=pool.create_vol(self)
      !new?
    end

    def destroy
      return true if new?
      @vol.delete
      fetch_volume
      new?
    end

    def path; end

    protected

    def name= name
      raise "invalid name" if name.nil?
      @name = name
    end

    def default_allocated_size
      0
    end

    # default image size in GB
    def default_size
      8
    end

    def fetch_volume
      @vol = pool.find_volume_by_name(name)
    end

    # abstracted methods

    def default_type; end

    def default_template_path; end
  end
end
