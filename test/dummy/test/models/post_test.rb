require 'test_helper'

class PostTest < ActiveSupport::TestCase
  
  test "attributes can be added to @tracked_attr variable" do
    assert_nil Post.tracked

    Post.tracks(:title)
    assert Post.tracked.last == :title, "title should be tracked"

    Post.tracks(:body)
    assert Post.tracked.last == :body, "body should be tracked"

    Post.tracks(:name)
    assert_not Post.tracked.last == :name, "name should not be tracked"
  end

end
