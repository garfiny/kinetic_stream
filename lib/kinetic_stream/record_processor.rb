module KineticStream
  # TODO failover, recovery, and load balancing functionality
  class RecordProcessor
    RUNNING = 'running'
    CLOSED  = 'closed'
    READY   = 'ready'
    ABORT   = 'abort_on_error'

    attr_reader :status

    def initialize(stream, shard, client)
      @client  = client
      @stream  = stream
      @shard   = shard
      @options = {stream_name: stream.name, shard_id: shard.id}
      @status  = READY
      @shutdown_triggered = false
    end

    {process_after_seq: 'AFTER_SEQUENCE_NUMBER' , process_from_seq: 'AT_SEQUENCE_NUMBER'}.each do |method_name, value|
      define_method(method_name) do |starting_sequence_number, limit = 20, abort_on_fail = false, block = nil|
        opts = @options.merge({
          shard_iterator_type: value,
          starting_sequence_number: starting_sequence_number
        })
        process(opts, limit, abort_on_fail, block)
      end
    end

    {process_from_latest: 'LATEST' ,  process_from_oldest: 'TRIM_HORIZON'}.each do |method_name, value|
      define_method(method_name) do |limit = 20, abort_on_fail = false, block = nil|
        opts = @options.merge({ shard_iterator_type: value })
        process(opts, limit, abort_on_fail, block)
      end
    end

    def terminate!
      @shutdown_triggered = true
    end

    private
    def process(opts, limit, abort_on_fail = false, &block)
      @status = RUNNING
      next_shard_iterator = kinesis_client.get_shard_iterator(opts)
      while next_shard_iterator
        break if @shutdown_triggered
        response = kinesis_client.get_records(shard_iterator: next_shard_iterator, limit: limit)
        next_shard_iterator = response[:next_shard_iterator]
        records = response[:records]
        if block
          begin
            block.call(records) 
          rescue => e
            if abort_when_fail
              @status = ABORT
              return
            end
          end
        end
      end
      @status = CLOSED
    end

    def kinesis_client
      @client.kinesis_client
    end
  end
end
