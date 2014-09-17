module KineticStream
  class Stream
    attr_reader :name

    def initialize(stream_name, client)
      @shards = {}
      @name   = stream_name
      @arn    = nil
      @client = client
      @loaded = false
    end

    def status
      stream_description[:stream_status]
    end

    def reload!
      load_from_remote
    end

    def arn
      load_from_remote unless @loaded
      @arn
    end

    def shards
      load_from_remote unless @loaded
      @shards
    end

    private
    def load_from_remote
      desc    = stream_description
      @arn    = desc[:stream_arn]
      @shards = desc[:shards].map { |s| KineticStream::Shard.new s }
      @loaded = true
    end

    def stream_description
      @client.kinesis_client.describe_stream(stream_name: self.name)[:stream_description]
    end
  end
end
