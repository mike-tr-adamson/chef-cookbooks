#export MAVEN_OPTS="-Djavax.net.ssl.trustStore=/home/mike/keys/archiva.jks -Djavax.net.ssl.trustStorePassword=Mikado1 -Djavax.net.ssl.trustStoreType=JKS -Djavax.net.ssl.keyStore=/home/mike/keys/mike.p12 -Djavax.net.ssl.keyStoreType=pkcs12 -Djavax.net.ssl.keyStorePassword=Mikado1"
#export GRADLE_OPTS=$MAVEN_OPTS

encrypted_users = data_bag('users')

users = []

encrypted_users.each do |encrypted_user|
	user = Chef::EncryptedDataBagItem.load("users", encrypted_user)
	if node['gradle']['ssl_users'].include?(user['name'])
		users << user
	end
end

users.each do |user|
	ruby_block "Set gradle path for user #{user['name']}" do
	  block do
		file = Chef::Util::FileEdit.new("/home/#{user['name']}/.bashrc")
		file.insert_line_if_no_match(
		  "# Set gradle ssl options",
		  "\n# Set gradle ssl options\nexport GRADLE_OPTS=\"-Djavax.net.ssl.trustStore=/home/#{user['name']}/.keys/trust.jks -Djavax.net.ssl.trustStorePassword=#{user['trust_password']} -Djavax.net.ssl.trustStoreType=JKS -Djavax.net.ssl.keyStore=/home/#{user['name']}/keys/client.p12 -Djavax.net.ssl.keyStoreType=pkcs12 -Djavax.net.ssl.keyStorePassword=#{user['client_password']}\""
		)
		file.write_file
	  end
	end	
end


