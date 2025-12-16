module ApplicationHelper
    def error_class(object, field)
    "field-error" if object.errors[field].any?
  end

  def error_message(object, field)
    content = object.errors.full_messages_for(field).first
    content_tag(:p, content, class: "inline-error")
  end
end
