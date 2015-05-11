class DeviseMailer < Devise::Mailer
  helper :application # gives access to all helpers defined within `application_helper`.
  include Devise::Controllers::UrlHelpers # Optional. eg. `confirmation_url`
  default template_path: 'devise/mailer' # to make sure that your mailer uses the devise viewsend

  def confirmation_instructions(record, token, opts={})
    if record.is_student?
      opts[:to] = record.cid + "@imperial.ac.uk"
    end
    super
  end

  def approval_instructions(record, token, opts={})
    @token = token
    opts[:to] = "cpp@doc.ic.ac.uk"
    devise_mail(record, :approval_instructions, opts)
  end

end
