# typed: true
# frozen_string_literal: true
require_relative('../test_helper')

module Bundix
  class PlatformResolverTest < MiniTest::Test
    def test_platform_resolver
      act = PlatformResolver.resolve(['rbx_26', 'mingw'])
      exp = [{ 'engine' => 'rbx', 'version' => '2.6' }, { 'engine' => 'mingw' }]
      assert_equal(act, exp)

      act = PlatformResolver.resolve(['ruby_21', 'ruby_22'])
      exp = [
        { 'engine' => 'ruby',   'version' => '2.1' },
        { 'engine' => 'rbx',    'version' => '2.1' },
        { 'engine' => 'maglev', 'version' => '2.1' },
        { 'engine' => 'ruby',   'version' => '2.2' },
        { 'engine' => 'rbx',    'version' => '2.2' },
        { 'engine' => 'maglev', 'version' => '2.2' },
      ]
      assert_equal(act, exp)
    end
  end
end
