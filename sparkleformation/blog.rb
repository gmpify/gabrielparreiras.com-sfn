SparkleFormation.new(:blog, :provider => :aws) do
  AWSTemplateFormatVersion '2010-09-09'

  parameters do
    bucket_name.type 'String'
    error_document.type 'String'
    index_document.type 'String'
    domain_hosted_zone_id.type 'String'
  end

  mappings.s3_website_endpoint do
    set!('us-east-1'._no_hump,
      :website_endpoint => 's3-website.us-east-1.amazonaws.com',
      :hosted_zone_id => 'Z3AQBSTGFYJSTF'
    )
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

  dynamic!(:route53_record_set, :blog) do
    properties do
      alias_target do
        d_n_s_name map!(:s3_website_endpoint, 'us-east-1', :website_endpoint)
        hosted_zone_id map!(:s3_website_endpoint, 'us-east-1', :hosted_zone_id)
      end
      hosted_zone_id ref!(:domain_hosted_zone_id)
      name ref!(:bucket_name)
      type 'A'
    end
  end
end
