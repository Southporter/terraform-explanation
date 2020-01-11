output "db_url" {
  value = aws_rds_cluster.webserver_database_cluster.endpoint
}

output "webserver_ip" {
  value = aws_instance.webserver.private_ip
}

output "webserver_dns" {
  value = aws_route53_record.dns_record.fqdn
}
