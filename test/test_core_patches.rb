require 'test/unit'

class Klass

  def initialize

    inject_callbacks
  end

  def _50__klass__after_extract__callback(_)

    "valid??"
  end
end

class TestCorePatches < Test::Unit::TestCase

  def test_hash

    assert_equal(Hash.new, Hash.new.extract)
    assert_equal({1 => 2}, {1 => 2}.extract)
  end

  def test_array

    assert_equal(Array.new, Array.new.extract)
    assert_equal([1, 2], [1, 2].extract)
  end

  def test_object

    obj = Object.new
    assert_equal(obj, obj.extract)
  end

  def test_callback_injection

    obj = Object.new
    obj.on(:after_extract) { |_| "valid?" }
    assert_equal("valid?", obj.extract)
  end

  def test_class_method_callback_injection

    assert_equal("valid??", Klass.new.extract)
  end
end
