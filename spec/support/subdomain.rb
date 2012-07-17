module SubdomainSpec
  def self.included(base)
    base.instance_eval <<-RUBY
      let(:default_question_set) do
        create :question_set, name: 'gasmixer'
      end

      before(:each) do
        request.host = 'gasmixer.test.host'
      end
    RUBY
  end
end
