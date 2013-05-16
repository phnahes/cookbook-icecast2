# Instalacao de Pacotes Necessarios
node['icecast2']['pkgs_install'].each do |pkg|
	package pkg
end


