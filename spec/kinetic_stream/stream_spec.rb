require 'spec_helper'

describe KineticStream::Stream do
  let(:stream_name) { 'anyname' }
  let(:client)      { double('client') }
  let(:stream)      { KineticStream::Stream.new stream_name, client }
  describe '#status' do
    it 'returns current stream status' do
      stream.status
    end
  end

  describe '#reload!'

  describe '#shard_ids'

  describe '#shard'
end
