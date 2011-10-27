module Virt::VMWare
  class Volume < Virt::Volume

    def default_type
      "raw"
    end

    def default_template_path
      "vmware/volume.xml.erb"
    end

    def path
      "[#{pool.name}] #{name}/#{name}.vmdk"
    end

    def name= name
      super name
      @name += ".vmdk" unless name.match(/.*\.vmdk$/)
    end


  end
end
