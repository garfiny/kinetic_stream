module KineticStream
  class Application
    attr_reader :application_name, :stream_name

    def initialize(app_name, stream_name, options = {})
      @application_name = app_name
      @stream_name      = stream_name
      @client           = KineticStream::Client.new(
        options.select{ |k,_| [:access_key_id, :secret_access_key].include? k }
      )
    end

    def stream
      @stream ||= KineticStream::Stream.new(@stream_name, @client)
    end

    def record_processors
      @stream.shards.map { |shard| KineticStream::RecordProcessor.new shard, @client }
    end
  end
end
