module KineticStream
  class StreamManager
    def initialize(client)
      @client = client
    end

    def merge_shards(shard_to_merge, adjacent_shard_to_merge)
      @client.kinesis_client.merge_shards stream_name: stream_name,
        shard_to_merge: shard_to_merge,
        adjacent_shard_to_merge: adjacent_shard_to_merge
    end

    def split_shard(shard_to_split, new_starting_hash_key)
      @client.kinesis_client.split_shard stream_name: stream_name,
        shard_to_split: shard_to_split,
        new_starting_hash_key: new_starting_hash_key
    end
  end
end
