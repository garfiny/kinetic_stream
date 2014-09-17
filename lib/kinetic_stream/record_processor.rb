module KineticStream
  class RecordProcessor
    def initialize(stream, shard, client)
      @client = client
      @stream = stream
      @shard  = shard
      @options = {stream_name: stream.name, shard_id: shard.id}
    end

    {process_after_seq: 'AFTER_SEQUENCE_NUMBER' , process_from_seq: 'AT_SEQUENCE_NUMBER'}.each do |method_name, value|
      define_method(method_name) do |starting_sequence_number, limit = 20, abort_on_fail = false, block = nil|
        opts = @options.merge({
          shard_iterator_type: value,
          starting_sequence_number: starting_sequence_number
        })
        Thread.new { process(limit, abort_on_fail, block) }
      end
    end

    {process_from_latest: 'LATEST' ,  process_from_oldest: 'TRIM_HORIZON'}.each do |method_name, value|
      define_method(method_name) do |limit = 20, abort_on_fail = false, block = nil|
        opts = @options.merge({ shard_iterator_type: value })
        Thread.new { process(limit, abort_on_fail, block) }
      end
    end

    private
    def process(opts, limit, abort_on_fail = false, &block)
      next_shard_iterator = kinesis_client.get_shard_iterator(opts)
      while next_shard_iterator
        response = kinesis_client.get_records(shard_iterator: next_shard_iterator, limit: limit)
        next_shard_iterator = response[:next_shard_iterator]
        records = response[:records]
        if block
          begin
            block.call(records) 
          rescue => e
            return if abort_when_fail
          end
        end
      end
    end

    def kinesis_client
      @client.kinesis_client
    end
  end
end
