require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test "full title helper" do
    assert_equal full_title, "First App"
    assert_equal full_title("Helper"), "Helper | First App"
  end
end
