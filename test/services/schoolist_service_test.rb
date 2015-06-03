require 'test_helper'

class SchoolistServiceTest < ActiveSupport::TestCase
  attr_reader :service

  def setup
    @service = SchoolistService.new
  end

  test '#schools' do
    VCR.use_cassette('schoolist_service#schools') do
      schools = service.schools
      school = schools.first

      assert_equal "010601", school['uid']
      assert_equal "18.1", school['obese_percentage']
      assert_equal "15.9", school['overweight_percentage']
    end
  end

  test '#school' do
    VCR.use_cassette('schoolist_service#school') do
      school = service.school(10)

      assert_equal "022101", school['uid']
      assert_equal "18.2", school['obese_percentage']
      assert_equal "20.8", school['overweight_percentage']
    end
  end

  test '#create_school' do
    VCR.use_cassette('schoolist_service#create_school') do
      school_params = { school: { uid: "123", overweight_percentage: "12.3", obese_percentage: "19"}}
      assert_difference("service.schools.count", 1) do
        school = service.create_school(school_params)

        assert_equal "123", school["uid"]
        assert_equal "12.3", school["overweight_percentage"]
        assert_equal "19.0", school["obese_percentage"]

        service.destroy_school(school[:id])
      end
    end
  end

  test '#update_school' do

    VCR.use_cassette('schoolist_service#update_school') do
      original_params = { school: { uid: "123", overweight_percentage: "32.3", obese_percentage: "14"}}
      original_school = service.create_school(original_params)


      updated_params = { school: { uid: "999", overweight_percentage: "12.3", obese_percentage: "19"}}
      service.update_school(original_school['id'], updated_params)
      updated_school = service.school(original_school['id'])

      refute_equal original_school['uid'],                    updated_school['uid']
      refute_equal original_school['overweight_percentage'],  updated_school['overweight_percentage']
      refute_equal original_school['obese_percentage'],       updated_school['obese_percentage']

      assert_equal "999", updated_school['uid'],                      updated_school['uid']
      assert_equal "12.3", updated_school['overweight_percentage'],    updated_school['overweight_percentage']
      assert_equal "19.0", updated_school['obese_percentage'],         updated_school['obese_percentage']
    end
  end
end
