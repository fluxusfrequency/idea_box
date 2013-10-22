require './test/helpers/unit_helper.rb'
require './lib/idea_box'

class SMSTest < Minitest::Test

  def setup
    SMSStore.filename = 'db/test_sms'
  end

  def teardown
    SMSStore.delete_all
  end

  def test_it_can_set_up_attrs
    sms = SMS.new({
      'id'           => 1,
      'from'         => +7192907974,
      'body'         => "This is only a test",
      'created_at'   => Time.now,
      })
    assert_respond_to sms, :id
    assert_respond_to sms, :from
    assert_respond_to sms, :body
    assert_respond_to sms, :created_at
  end

  def test_the_SMS_store_can_create_smss
    sms = SMS.new({
      'id'           => 1,
      'from'         => +7192907974,
      'body'         => "This is only a test",
      'created_at'   => Time.now,
      })
    assert SMSStore.create(sms.to_h)
  end

  def test_the_ids_increment
    sms1 = {
      'from'         => 7192907974,
      'body'         => "This is only a test",
      'created_at'   => Time.now,
      }
    sms2 = {
      'from'         => 7192907974,
      'body'         => "Testing 2",
      'created_at'   => Time.now,
      }
    sms3 = {
      'from'         => 7192907974,
      'body'         => "Testing 3",
      'created_at'   => Time.now,
      }
    sms4 = {
      'from'         => 7192907974,
      'body'         => "Testing 4",
      'created_at'   => Time.now,
      }
    SMSStore.create(sms1.to_h)
    SMSStore.create(sms2.to_h)
    SMSStore.create(sms3.to_h)
    SMSStore.create(sms4.to_h)

    assert SMSStore.find(1).id.to_i == 1
    assert SMSStore.find(2).id.to_i == 2
    assert SMSStore.find(3).id.to_i == 3
    assert SMSStore.find(4).id.to_i == 4
  end

  def test_the_SMS_store_can_show_all_smss
    sms1 = SMS.new({
      'id'           => 1,
      'from'         => +7192907974,
      'body'         => "This is only a test",
      'created_at'   => Time.now,
      })
    sms2 = SMS.new({
      'id'           => 2,
      'from'         => +7192907974,
      'body'         => "Testing 2",
      'created_at'   => Time.now,
      })
    SMSStore.create(sms1.to_h)
    SMSStore.create(sms2.to_h)
    assert_equal 2, SMSStore.all.length
  end

end