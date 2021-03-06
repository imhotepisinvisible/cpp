# Sanitize::Rails example configuration
#
# https://github.com/vjt/sanitize-rails
#
# Enjoy, Share and Love <3
#
#   -- vjt@openssl.it
#
HTML::WhiteListSanitizer.allowed_css_properties   = %w(text-align background-color)
HTML::WhiteListSanitizer.shorthand_css_properties = %w()
HTML::WhiteListSanitizer.allowed_css_keywords     = %w(left center right justify rgb)

engine = HTML::WhiteListSanitizer.new

css_sanitizer = lambda {|options|
  node = options[:node]
  if node.present? && node.element? && node['style'].present?
    node['style'] = engine.sanitize_css node['style']
  end
}

div_transformer = lambda {|options|
  node = options[:node]
  if node.present? && node.element? && node.name.downcase == 'div'
    node.name = 'p'
  end
}

ie_cleaner = lambda {|options|
  node = options[:node]
  return unless node.present? && node.element?

  if align = node['align']
    node['style'] = "text-align: #{align};"
  end

  if node.name.downcase == 'font'
    node.name = 'span'
  end
}

Sanitize::Rails.configure(
  :elements => %w[ a b blockquote br div em i li ol p span strong u ul ],

  :attributes => {
    :all  => ['style'],
    'a'   => ['href']
  },

  :add_attributes => {
    'a' => {
      'rel'    => 'nofollow',
      'target' => '_blank'
    }
  },

  :protocols => {
    'a' => {'href' => ['ftp', 'http', 'https', 'mailto', :relative]}
  },

  :transformers => [css_sanitizer, div_transformer, ie_cleaner],

  :whitespace_elements => %w(
    address article aside blockquote dd dl dt footer
    h1 h2 h3 h4 h5 h6 header hgroup hr nav pre section
    tr td option input
  )
)
