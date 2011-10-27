require 'test/test_helper'

class Virt::VolumeTest < Test::Unit::TestCase

  def setup
    hostname = "h01.sat.lab"
    uri = "qemu+ssh://root@#{hostname}/system"
    Virt.connect(uri)
    @vol = Virt::KVM::Volume.new({:name => "mytestvol-#{Time.now}"})
  end

  def test_should_be_new
    assert @vol.new?
  end

  def test_should_create_volume
    assert @vol.save
    @vol.destroy
  end

  def test_should_destroy_volume
    assert @vol.save
    assert @vol.destroy
  end



end
