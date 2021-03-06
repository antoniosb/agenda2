module LayoutHelper
  def flash_messages(opt={})
    @layout_flash = opt.fetch(:layout_flash) { true }

    capture do
      flash.each do |name, msg|
        concat content_tag(:div, msg, id: "flash_#{name}")
      end
    end
  end

  def show_layout_flash?
    @layout_flash.nil? ? true : @layout_flash
  end


  def resource_error_messages(resource)
    return "" if resource.errors.empty?

    messages = resource.errors.full_messages.map { |msg| content_tag(:div, msg) }.join
    sentence = I18n.t("errors.messages.not_saved",
                      :count => resource.errors.count,
                      :resource => resource.class.model_name.human.downcase)

    html = <<-HTML
    <div class='alert alert-danger'>
    <span class="glyphicon glyphicon-remove-sign"></span>
      <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
      <strong>#{sentence}</strong></br>
        #{messages}
    </div>
    HTML

    html.html_safe
  end

  def resource_error_messages?(resource)
    !resource.errors.empty?
  end







end