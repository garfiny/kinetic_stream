module KineticStream
  class Client
    def initialize(settings = {})
      @kinesis = AWS::Kinesis.new(
        access_key_id:     settings[:access_key_id],
        secret_access_key: settings[:secret_access_key]
      )
    end

    def kinesis_client
      @kinesis.client
    end

    def create_stream(stream_name, shard_count = 2)
      self.kinesis_client.create_stream stream_name: stream_name, shard_count: shard_count
      self.fetch_stream stream_name
    end

    def delete_stream(stream_name)
      self.kinesis_client.delete_stream stream_name: stream_name
    end

    def list_streams(limit = 999)
      # the result hash looks like this
      # {:stream_names=>["stream A", "stream B"], :has_more_streams=>false}
      self.kinesis_client.list_streams limit: limit
    end
    
    def fetch_stream(stream_name, lazy_fetch = true)
       KineticStream::Stream.new(stream_name, self).tap { |s| s.reload! unless lazy_fetch }
    end
  end
end
