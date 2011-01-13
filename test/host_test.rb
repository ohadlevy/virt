require 'test/test_helper'

class Virt::HostTest < Test::Unit::TestCase

  def setup
    hostname = "h01.sat.lab"
    uri = "qemu+ssh://root@#{hostname}/system"
    @host = Virt.connect(uri).host
  end

  def test_should_have_a_name
    assert_kind_of String, @host.name
  end

  def test_should_return_running_guests
    assert_kind_of Virt::Guest, @host.running_guests.first
  end

  def test_should_return_defined_guests
    assert_kind_of Virt::Guest, @host.defined_guests.first
  end

  def test_should_return_interfaces
    assert @host.interfaces
  end

  def test_should_return_networks
    assert @host.networks
  end

  def test_should_return_a_storage_pool
    assert_kind_of Virt::Pool, @host.storage_pool("default")
  end

  def test_should_return_storage_pools
    assert @host.storage_pools
  end

  def test_should_return_volumes
    assert @host.volumes
  end

end
