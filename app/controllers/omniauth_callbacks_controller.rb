class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  # Extend the standard message generation to accept our custom exception
  def failure_message
    exception = env["omniauth.error"]
    if exception.class == OmniAuth::Error
      error = exception.message
    else
      error   = exception.error_reason if exception.respond_to?(:error_reason)
      error ||= exception.error        if exception.respond_to?(:error)
      error ||= env["omniauth.error.type"].to_s
    end
    error.to_s.humanize if error
  end
 
  def ldap
    # We only find ourselves here if the authentication to LDAP was successful.
    info = request.env["omniauth.auth"]["info"]
    @user = User.find_for_ldap_auth(info)
    if @user.persisted?
      @user.remember_me = true
    end
    sign_in_and_redirect @user
  end

end
