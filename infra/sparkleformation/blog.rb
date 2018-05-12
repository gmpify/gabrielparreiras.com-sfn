SparkleFormation.new(:blog, :provider => :aws) do
  AWSTemplateFormatVersion '2010-09-09'

  parameters do
    bucket_name.type 'String'
  end

  dynamic!(:s3_bucket, :blog) do
    properties do
      bucket_name ref!(:bucket_name)
    end
  end
end
