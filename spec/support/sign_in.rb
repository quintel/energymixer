module SignIn
  # Signs a user in to the admin area in integration tests.
  #
  # @param [String, User] user
  #   The user's login name (e-mail address). If a password (second param) is
  #   omitted, "login" should be a User instance.
  # @param [String] password
  #   The user's password.
  #
  def sign_in(user, password = nil)
    if user.kind_of?(User)
      login    = user.email
      password = user.password unless password.present?
    else
      login    = user.to_s
    end

    visit 'http://gasmixer.mixer.dev:54163/admin'

    fill_in 'Email',    with: login
    fill_in 'Password', with: password

    click_button 'Sign in'

    # Sanity check.
    page.should_not have_content('Sign in')
  end
end # SignIn
