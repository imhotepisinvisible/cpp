Paperclip.interpolates(:s3_eu_url) { |attachment, style|
  "#{attachment.s3_protocol}://s3-eu-west-1.amazonaws.com/#{attachment.bucket_name}/#{attachment.path(style).gsub(%r{^/}, "")}"
}

module Paperclip
  module Storage
    module S3
     def expiring_url(style = default_style, time = 20)
        AWS::S3::S3Object.url_for(path(style),
                                  bucket_name,
                                  :expires_in => time,
                                  :use_ssl => true)
     end
    end
  end
end
