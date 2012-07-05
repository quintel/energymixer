module SubdomainSpec
  def self.included(base)
    base.instance_eval <<-RUBY
      before(:each) do
        # request.expects(:subdomain).at_least_once.returns('gasmixer')
        request.host = 'gasmixer.test.host'
      end
    RUBY
  end
end
