require 'net/ftp'
require 'net/sftp'

module Codewatch

	class ImplementMeException < Exception
	end

	class HostUnreachable < Exception
	end

	class PortUnreachable < Exception
	end

	class WrongCredentials < Exception
	end

	class PathNotAccessible < Exception
	end

	class PathNotWritable < Exception
	end

	class ServerConnection

		def initialize host, port, username, password, type
			@host, @port, @username, @password, @type, @current_dir = host, port, username, password, type, ''
		end

		def open
			raise ImplementMeException
		end

		def close
			raise ImplementMeException
		end

		def chdir dir

			if @current_dir == ''
				@current_dir = dir
			else

				if dir == '..'

					parts = @current_dir.reverse.split File::SEPARATOR, 2

					if parts.length == 2
						@current_dir = parts[1].reverse
					else
						@current_dir = ''
					end
				else
					@current_dir = File.join @current_dir, dir
				end
			end
		end

		def mkdir
			raise ImplementMeException
		end

		def rmdir
			raise ImplementMeException
		end

		def put
			raise ImplementMeException
		end

		def put_binary
			raise ImplementMeException
		end

		def delete
			raise ImplementMeException
		end
	end

	class FTPServerConnection < ServerConnection

		def open

			begin

				@ftp = Net::FTP.new

				@ftp.passive = @type == Server::Type::FTP_PASSIVE
				@ftp.binary = true

				@ftp.connect @host, @port
				@ftp.login @username, @password
			rescue SocketError
				raise HostUnreachable
			rescue Errno::ECONNREFUSED
				raise PortUnreachable
			rescue Net::FTPPermError
				raise WrongCredentials
			rescue Exception
				raise HostUnreachable
			end
		end

		def close
			@ftp.quit
		end

		def chdir dir
			begin
				super dir
				@ftp.chdir dir
			rescue Net::FTPPermError
				raise PathNotAccessible.new (File.join @current_dir, dir)
			end
		end

		def mkdir dir
			begin
				@ftp.mkdir dir
			rescue Net::FTPPermError
				raise PathNotWritable.new (File.join @current_dir, dir)
			end
		end

		def rmdir dir
			begin
				@ftp.rmdir dir
			rescue Net::FTPPermError
				raise PathNotWritable.new (File.join @current_dir, dir)
			end
		end

		def put file
			begin
				@ftp.put file
			rescue Net::FTPPermError
				raise PathNotWritable.new (File.join @current_dir, file)
			end
		end

		def put_binary file_name, data
			begin
				@ftp.storbinary "STOR " + file_name, StringIO.new(data), Net::FTP::DEFAULT_BLOCKSIZE
			rescue Net::FTPPermError
				raise PathNotWritable.new (File.join @current_dir, file_name)
			end
		end

		def delete file
			begin
				@ftp.delete file
			rescue Net::FTPPermError
				raise PathNotWritable.new (File.join @current_dir, file)
			end
		end
	end

	class SFTPServerConnection < ServerConnection

		def open

			begin
				@sftp = Net::SFTP.start @host, @username, :password => @password, :port => @port
			rescue SocketError
				raise HostUnreachable
			rescue Errno::ECONNREFUSED
				raise PortUnreachable
			rescue Net::SSH::AuthenticationFailed
				raise WrongCredentials
			rescue Exception
				raise HostUnreachable
			end
		end

		def close
			@sftp.close_channel
		end

		def chdir dir
			begin
				super dir
				if @current_dir != ''
					handle = @sftp.opendir! @current_dir
					@sftp.close handle
				end
			rescue Net::SFTP::StatusException
				raise PathNotAccessible.new (File.join @current_dir, dir)
			end
		end

		def mkdir dir
			begin
				if @current_dir == ''
					@sftp.mkdir! dir
				else
					@sftp.mkdir! File.join @current_dir, dir
				end
			rescue Net::SFTP::StatusException
				raise PathNotWritable.new (File.join @current_dir, dir)
			end
		end

		def rmdir dir
			begin
				if @current_dir == ''
					@sftp.rmdir! dir
				else
					@sftp.rmdir! File.join @current_dir, dir
				end
			rescue Net::SFTP::StatusException
				raise PathNotWritable.new (File.join @current_dir, dir)
			end
		end

		def put file
			begin
				if @current_dir == ''
					@sftp.upload! file, file
				else
					@sftp.upload! file, (File.join @current_dir, file)
				end
			rescue Net::SFTP::StatusException
				raise PathNotWritable.new (File.join @current_dir, file)
			end
		end

		def put_binary file_name, data

			begin

				if @current_dir == ''
					handle = @sftp.open! file_name, 'w'
				else
					handle = @sftp.open! (File.join @current_dir, file_name), 'w'
				end

				@sftp.write! handle, 0, data
				@sftp.close! handle
			rescue Net::SFTP::StatusException
				raise PathNotWritable.new (File.join @current_dir, file_name)
			end
		end

		def delete file
			begin
				if @current_dir == ''
					@sftp.remove! file
				else
					@sftp.remove! (File.join @current_dir, file)
				end
			rescue Net::SFTP::StatusException
				raise PathNotWritable.new (File.join @current_dir, file)
			end
		end
	end
end
