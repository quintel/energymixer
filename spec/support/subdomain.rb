module SubdomainSpec
  def self.included(base)
    base.instance_eval <<-RUBY
      let(:default_question_set) do
        create :question_set, name: 'gasmixer'
      end

      before(:each) do
        request.host = '%s.test.host' % default_question_set.name
      end
    RUBY
  end
end
