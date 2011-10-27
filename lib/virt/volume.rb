module Virt
  class Volume
    include Virt::Util
    attr_reader :name, :pool, :type, :allocated_size, :size, :template_path, :key, :xml_desc

    def initialize options = {}
      @connection     = Virt.connection
      self.name       = options[:name]           || raise("Volume requires a name")
      # If our volume already exists, we ignore the provided options and defaults
      fetch_volume
      @type           ||= options[:type]           || default_type
      @allocated_size ||= options[:allocated_size] || default_allocated_size
      @template_path  ||= options[:template_path]  || default_template_path
      @size           ||= options[:size]           || default_size
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
#TODO FIX THIS
      @pool           ||= options[:pool].nil? ? default_pool : @connection.host.storage_pool(options[:pool])
      @vol = pool.find_volume_by_name(name)
      fetch_info
    end

    def fetch_info
      return if @vol.nil?
      # parse through xml to get the attributes
      @xml_desc         = @vol.xml_desc
      @size             = document("volume/capacity")
      @allocated_size   = document("volume/allocation")
      @name             = document("volume/name").split('/')[1]
      @path    = document("volume/target/path")
    end

    def default_pool
      @connection.host.storage_pools.first
    end

    # abstracted methods

    def default_type; end

    def default_template_path; end
  end
end
