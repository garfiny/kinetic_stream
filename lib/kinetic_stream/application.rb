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

    def merge_shards(shard_to_merge, adjacent_shard_to_merge)
      @client.kinesis_client.merge_shards stream_name: stream_name,
        shard_to_merge: shard_to_merge,
        adjacent_shard_to_merge: adjacent_shard_to_merge
      @stream.reload!
    end

    def split_shard(shard_to_split, new_starting_hash_key)
      @client.kinesis_client.split_shard stream_name: stream_name,
        shard_to_split: shard_to_split,
        new_starting_hash_key: new_starting_hash_key
      @stream.reload!
    end
  end
end
