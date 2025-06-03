module ProfilesHelper
  def profile_avatar(profile, size: 40, css_class: 'rounded-circle')
    if profile&.avatar&.attached?
      image_tag profile.avatar, 
                class: css_class, 
                size: "#{size}x#{size}",
                alt: "Avatar de #{profile.full_name}"
    else
      content_tag :div, 
                  profile&.full_name&.first&.upcase || '?',
                  class: "#{css_class} bg-secondary text-white d-flex align-items-center justify-content-center",
                  style: "width: #{size}px; height: #{size}px; font-size: #{size/2}px;"
    end
  end

  def profile_display_name(profile)
    return 'Usuário' unless profile
    
    if profile.first_name.present? || profile.last_name.present?
      profile.full_name.strip
    else
      'Usuário'
    end
  end
end
