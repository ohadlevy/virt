module Virt::KVM
  class Volume < Virt::Volume

    def default_type
      "raw"
    end

    def default_template_path
      "kvm/volume.xml.erb"
    end

    def path
      "#{pool.path}/#{name}"
    end

    def name= name
      super name
      @name += ".img" unless name.match(/.*\.img$/)
    end


  end
end
