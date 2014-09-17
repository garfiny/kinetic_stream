module KineticStream
  class RecordProcessor
    def initialize(client, stream_name)
      @client = client
      @stream_name = stream_name
    end

    # TODO add different record putting strategy
    def put(data, partition_key, explicit_hash_key = nil, sequence_number_for_ordering = nil)
      params = { data: data, stream_name: stream_name, partition_key: partition_key }
      params[:explicit_hash_key] = explicit_hash_key if explicit_hash_key
      params[:sequence_number_for_ordering] = sequence_number_for_ordering if sequence_number_for_ordering 
      @client.put_record params
    end
  end
end
