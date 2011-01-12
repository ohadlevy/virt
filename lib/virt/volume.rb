module Virt
  class Volume
    include Virt::Util
    attr_reader :name, :pool, :path, :type, :allocated_size, :size, :template_path, :key

    def initialize options = {}
      @connection     = Virt.connection
      @name           = normalize_name options[:name]
      @type           = options[:type]           || default_type
      @allocated_size = options[:allocated_size] || default_allocated_size
      @template_path  = options[:template_path]  || default_template_path
      @size           = options[:size]           || default_size
      @pool           = @connection.host.storage_pool(options[:pool] || "default")
      fetch_volume
    end

    def new?
      @vol.nil?
    end

    def save
      raise "volume already exists, can't save" unless new?
      #validations
      #update?
      pool.create_vol self
      fetch_volume
    end

    def destroy
      return true if new?
      @vol.delete
    end

    def path
      "#{pool.path}/#{name}"
    end

    private

    def normalize_name name
      return name if name.match(/.*\.img$/)
      name += ".img"
    end

    def default_type
      "raw"
    end

    def default_allocated_size
      0
    end

    # default image size in GB
    def default_size
      8
    end

    def default_template_path
      "volume.xml.erb"
    end

    def fetch_volume
      @vol = pool.find_volume_by_name name
    end
  end
end
