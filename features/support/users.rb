def login_as(user)
  GDS::SSO.test_user = create(user)
  Capybara.reset_sessions!
end

def current_user
  GDS::SSO.test_user || User.first
end

def reset_authentication
  GDS::SSO.test_user = nil
  Capybara.reset_sessions!
end
