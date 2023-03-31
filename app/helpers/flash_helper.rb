module FlashHelper
  FLASH_CSS = { notice: :success, alert: :danger, welcome: :primary }

  def flash_messages(messages)
    flashes_html = messages.map do |key, value|
      content_tag(:p, value.to_s.html_safe, class: "alert alert-#{FLASH_CSS.fetch(key.to_sym, :notice)}")
    end.join('').html_safe
  end
end
