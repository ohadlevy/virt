module Virt::VMWare
  class Volume < Virt::Volume

    def default_type
      "raw"
    end

    def default_template_path
      "vmware/volume.xml.erb"
    end

    def path
      # this may not work correctly if user changes name of vm
      # this file should only be used to create new a vm
      "[#{pool.name}] #{self}"
    end

    def name= name
      super name
      # add .vmdk uless it already is appended
      @name += ".vmdk" unless name.match(/.*\.vmdk$/)
    end

    def to_s
      "#{title}/#{name}"
    end

    private

    def title
      name.chomp(".vmdk")
    end

#TODO: move to use our objects
    def fetch_volume
      # Get the pool name and resolve it to an object
      @pool = @connection.host.storage_pool(@poolname)
      @vol =  @pool.find_volume_by_name(to_s) if @pool
      fetch_info
    end

#TODO move some of it to the initializor
    def fetch_info
      return if @vol.nil?
      # parse through xml to get the attributes
      @xml_desc         = @vol.xml_desc
      @size             = to_gb(document("volume/capacity"))
      @allocated_size   = to_gb(document("volume/allocation"))
      @volname          = document("volume/name").split('/')[1]
      @template_path    = document("volume/target/path")
    end

  end
end
