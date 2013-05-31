module UsersHelper

  # Returns the Gravatar (http://gravatar.com/) for the given user.
  def gravatar_for(user)
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    gravater_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"
    image_tag(gravater_url, alt: user.name, class: "gravatar")
  end
end
