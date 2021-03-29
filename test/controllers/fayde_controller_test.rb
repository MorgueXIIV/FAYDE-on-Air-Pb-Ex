require 'test_helper'

class FaydeControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get fayde_index_url
    assert_response :success
  end

end
