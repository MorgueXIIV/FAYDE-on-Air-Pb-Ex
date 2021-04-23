Rails.application.config.after_initialize do
  if defined?(::Puma) && !Object.const_defined?('Puma::Server::UNPACK_TCP_STATE_FROM_TCP_INFO')
    ::Puma::Server::UNPACK_TCP_STATE_FROM_TCP_INFO = "C".freeze
  end
end
