SparkleFormation.new(:blog, :provider => :aws) do
  AWSTemplateFormatVersion '2010-09-09'

  parameters do
    bucket_name.type 'String'
    error_document.type 'String'
    index_document.type 'String'
  end

  dynamic!(:s3_bucket, :blog) do
    properties do
      bucket_name ref!(:bucket_name)
      website_configuration do
        error_document ref!(:error_document)
        index_document ref!(:index_document)
      end
    end
  end

  dynamic!(:s3_bucket_policy, :blog) do
    properties do
      bucket ref!(:blog_s3_bucket)
      policy_document do
        version '2012-10-17'
        statement _array(
          -> {
            sid 'AllowPublicRead'
            effect 'Allow'
            principal '*'
            action 's3:GetObject'
            resource join!(['arn:aws:s3:::', ref!(:bucket_name), '/*'])
          }
        )
      end
    end
  end
end
