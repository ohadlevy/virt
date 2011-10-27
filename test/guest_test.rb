require 'test/test_helper'

class Virt::GuestTest < Test::Unit::TestCase

  def setup
    hostname = "h02.sat.lab"
    uri = "qemu+ssh://root@#{hostname}/system"
    Virt.connect(uri)
    @guest = Virt::KVM::Guest.new({:name => "test-host-#{Time.now.to_i}"})
  end

  def teardown
    @guest.destroy
    Virt.connection.disconnect unless Virt.connection.closed?
  end

  def test_should_be_new
    assert @guest.new?
    assert @guest.interface.new?
    assert_nil @guest.interface.mac
  end

  def test_should_be_able_to_save
    assert @guest.save
    assert !@guest.interface.new?
    assert_not_nil @guest.interface.mac
  end

  def test_should_be_able_to_save_32bit_guest
    @guest.arch = "i386"
    assert_equal @guest.arch, "i686"
    assert @guest.save
    assert !@guest.interface.new?
    assert_not_nil @guest.interface.mac
  end

  def test_should_be_able_to_destroy
    assert @guest.save
    assert @guest.destroy
  end

  def test_should_be_able_to_save_and_start
    @guest = Virt::KVM::Guest.new({:name => "test-host-#{Time.now.to_i}", :device => "br180"})
    assert @guest.volume.save
    assert @guest.save
    assert @guest.start
    assert @guest.poweroff
    assert @guest.volume.destroy
    assert @guest.destroy
  end

end
