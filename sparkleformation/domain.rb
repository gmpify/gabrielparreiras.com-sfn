SparkleFormation.new(:domain, :provider => :aws) do
  AWSTemplateFormatVersion '2010-09-09'

  parameters do
    domain_name.type 'String'
  end

  dynamic!(:route53_hosted_zone, :domain) do
    properties do
      name ref!(:domain_name)
    end
  end

  outputs do
    domain_hosted_zone_id.value ref!(:domain_route53_hosted_zone)
  end
end
