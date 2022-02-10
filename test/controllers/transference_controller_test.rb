require "test_helper"

class TransferenceControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get transference_index_url
    assert_response :success
  end
end
