require 'test_helper'

class SchoolistServiceTest < ActiveSupport::TestCase
  test '#schools' do
    VCR.use_cassette('schoolist_service#schools') do
      schools = SchoolistService.new.schools
      school = schools.first

      assert_equal "010601", school['uid']
      assert_equal "18.1", school['obese_percentage']
      assert_equal "15.9", school['overweight_percentage']
    end
  end

  test '#school' do
    VCR.use_cassette('schoolist_service#school') do
      school = SchoolistService.new.school(10)

      assert_equal "022101", school['uid']
      assert_equal "18.2", school['obese_percentage']
      assert_equal "20.8", school['overweight_percentage']
    end
  end
end

