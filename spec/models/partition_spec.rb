require 'spec_helper'

describe Partition do
  let(:attributes) { {
    hostname:             'testapp.example.org',
    max_total_cost:       150,
    api_session_settings: { end_year: 2050 },
    default_locale:       'en',
    multilanguage:        false,
    score:                false,
    google_analytics_key: '123'
  } }

  subject { Partition.new('testapp', attributes) }

  its(:name)            { should eql('testapp')             }
  its(:host)            { should eql('testapp.example.org') }
  its(:max_cost)        { should eql(150)                   }
  its(:api_settings)    { should eql(end_year: 2050)        }
  its(:default_locale)  { should eql('en')                  }
  its(:analytics_key)   { should eql('123')                 }

  its(:multi_language?) { should be_false                   }
  its(:analytics?)      { should be_true                    }
  its(:show_score?)     { should be_false                   }

  it 'should be multi-language by default' do
    partition = Partition.new('name', attributes.except(:multilanguage))
    partition.multi_language?.should be_true
  end

  it 'should disable analytics by default' do
    partition = Partition.new('name', attributes.except(:google_analytics_key))
    partition.analytics?.should be_false
  end

  it 'should show score by default' do
    partition = Partition.new('name', attributes.except(:score))
    partition.show_score?.should be_true
  end

end
