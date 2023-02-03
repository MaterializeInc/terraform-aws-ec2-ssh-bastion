output "ssh_bastion_details" {
#     value = aws_instance.ssh_bastion
# }
  value = <<EOF
        -- Your IP is: ${aws_instance.ssh_bastion.public_ip}

        -- On Materialize:
            -- Create a SSH connection in Materialize:
            CREATE CONNECTION ssh_connection TO SSH TUNNEL (
                HOST '${aws_instance.ssh_bastion.public_ip}',
                USER 'ubuntu',
                PORT 22
            );

            -- Get the SSH private key for this connection:
            SELECT * FROM mz_ssh_tunnel_connections;

        -- On the EC2 instance:
            -- From another terminal, SSH into the bastion host with:
            -- ssh ubuntu@${aws_instance.ssh_bastion.public_ip}
            -- And then add the SSH key to the EC2 ~/.ssh/authorized_keys file:
            -- echo "ssh-ed25519 AAAA...76RH materialize" >> ~/.ssh/authorized_keys

        -- On Materialize:
            -- Create a Materialize Kafka connection:
            CREATE CONNECTION kafka_connection TO KAFKA (
            BROKERS (
                'broker1:9092' USING SSH TUNNEL ssh_connection,
                'broker2:9092' USING SSH TUNNEL ssh_connection
                )
            );

            -- Create a Materialize Postgres connection:
            CREATE SECRET pgpass AS '<POSTGRES_PASSWORD>';

            CREATE CONNECTION pg_connection TO POSTGRES (
                HOST 'YOUR_RDS_INSTANCE.foo000.us-west-1.rds.amazonaws.com',
                PORT 5432,
                USER 'postgres',
                PASSWORD SECRET pgpass,
                SSL MODE 'require',
                DATABASE 'postgres'
                SSH TUNNEL ssh_connection
            );
    EOF
}
