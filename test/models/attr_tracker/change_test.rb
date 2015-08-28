require 'test_helper'

module AttrTracker
  class ChangeTest < ActiveSupport::TestCase

    test "responds to trackable" do
      change = Change.new
      assert change.respond_to?(:trackable), "should respond to trackable"
    end

  end
end
