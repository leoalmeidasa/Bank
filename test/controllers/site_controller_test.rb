require "test_helper"

class SiteControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get site_index_url
    assert_response :success
  end
end
