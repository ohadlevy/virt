require 'test/test_helper'

class Virt::PoolTest < Test::Unit::TestCase

  def setup
    hostname = "h01.sat.lab"
    uri = "qemu+ssh://root@#{hostname}/system"
    host = Virt.connect(uri).host
    @pool = Virt::Pool.new({:name => host.storage_pools.first.name})
  end

  def test_pool_should_not_be_new
    assert !@pool.new?
  end

  def test_pool_should_have_volumes
    assert @pool.volumes
  end

  def test_find_vol_by_name
    assert_kind_of Libvirt::StorageVol, @pool.find_volume_by_name(@pool.volumes.first)
  end

  def test_should_not_find_unknown_volumes
    assert !@pool.find_volume_by_name("no such name")
  end

  def test_find_vol_by_key
    vol = @pool.find_volume_by_name(@pool.volumes.first)
    new_vol = @pool.find_volume_by_key(vol.key)
    # we cant compare the object themselfs, as libvirt returns a new object each time.
    assert_equal vol.key, new_vol.key
  end

end
