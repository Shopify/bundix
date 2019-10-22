# typed: true
# frozen_string_literal: true
require_relative('../test_helper')

class TestBundix < MiniTest::Test
  def test_parse_gemset
    gemset = 'test/data/path with space/gemset.nix'
    res = Bundix::RebuildGemsetFromLockfile.allocate.send(:parse_gemset, gemset)
    assert_equal({ 'a' => 1 }, res)
  end
end
