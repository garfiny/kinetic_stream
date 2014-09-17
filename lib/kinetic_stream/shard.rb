module KineticStream
  class Shard
    attr_reader :id, :parent_id, :adjacent_parent_id,
      :starting_hash_key, :ending_hash_key,
      :starting_sequence_number, :ending_sequence_number

    def initialize(hash = {})
      @id                  = hash[:shard_id]
      @parent_id           = hash[:parent_shard_id]
      @adjancent_parent_id = hash[:adjancent_parent_shard_id]

      if hash[:hash_key_range]
        @starting_hash_key = hash[:hash_key_range][:starting_hash_key] 
        @ending_hash_key   = hash[:hash_key_range][:ending_hash_key]
      end

      if hash[:sequence_number_range]
        @starting_sequence_number = hash[:sequence_number_range][:starting_sequence_number]
        @ending_sequence_number   = hash[:sequence_number_range][:ending_sequence_number]
      end
    end
  end
end
